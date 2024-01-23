import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/company/companies_bloc.dart';
import 'package:k3_sipp_mobile/logic/company/companies_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/company/company.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/company/company_row.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_search_field.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_shimmer.dart';

enum CompaniesPageMode { selectCompany, companyList }

class CompaniesPage extends StatefulWidget {
  final CompaniesPageMode pageMode;

  const CompaniesPage({super.key, required this.pageMode});

  @override
  State<CompaniesPage> createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {
  final CompaniesLogic _logic = CompaniesLogic();

  void _navigateTo(Company company) {
    switch (widget.pageMode) {
      case CompaniesPageMode.selectCompany:
        navigatorKey.currentState?.pop(company);
        return;
      case CompaniesPageMode.companyList:
      // TODO: navigate to detail user
    }
  }

  void _updateSearchText(String query) {
    _logic.searchKeywords = query;
    context.read<CompaniesBloc>().add(FetchCompaniesEvent(query: _logic.searchKeywords));
  }

  Widget _buildCompanies(List<Company> companies) {
    return Expanded(
      child: ListView.builder(
        itemCount: companies.length,
        itemBuilder: (context, index) => CompanyRow(
          company: companies.elementAt(index),
          onTap: () => _navigateTo(companies.elementAt(index)),
        ),
      ),
    );
  }

  Widget _buildNoData() {
    return Padding(
      padding: const EdgeInsets.only(top: Dimens.paddingMedium),
      child: Center(
        child: Text(
          "Tidak ada perusahaan.",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: ColorResources.warningText),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.only(top: Dimens.paddingMedium),
      child: Center(
        child: Text(
          "Our service is currently unavailable.",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: ColorResources.warningText),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Expanded(
      child: ListView.separated(
        physics: const ClampingScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) => const CustomShimmer(),
        separatorBuilder: (context, index) => const SizedBox(height: Dimens.paddingWidget),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingPage),
      child: RefreshIndicator(
        onRefresh: () async => context.read<CompaniesBloc>().add(FetchCompaniesEvent(query: _logic.searchKeywords)),
        child: Column(
          children: [
            CustomCard(
              child: CustomSearchField(
                key: _logic.searchKey,
                onFieldSubmitted: (value) async => _updateSearchText(value),
                onClearText: () {
                  _logic.searchKey.currentState?.clearText();
                  _updateSearchText("");
                },
              ),
            ),
            const SizedBox(height: Dimens.paddingWidget),
            BlocBuilder<CompaniesBloc, CompaniesState>(
              builder: (context, state) {
                if (state is CompaniesLoadingState) {
                  return _buildShimmer();
                } else if (state is CompaniesLoadedState) {
                  if (state.companies.isNotEmpty) {
                    return _buildCompanies(state.companies);
                  } else {
                    return _buildNoData();
                  }
                } else {
                  return _buildError();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<CompaniesBloc>().add(FetchCompaniesEvent(query: ""));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Perusahaan", style: Theme.of(context).textTheme.headlineLarge),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigatorKey.currentState?.pushNamed("/create_company"),
        backgroundColor: ColorResources.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _buildBody(),
    );
  }
}

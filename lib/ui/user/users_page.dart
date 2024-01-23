import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/user/users_bloc.dart';
import 'package:k3_sipp_mobile/logic/user/users_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_search_field.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_shimmer.dart';
import 'package:k3_sipp_mobile/widget/user/user_row.dart';

enum UsersPageMode { selectUser, userList }

class UsersPage extends StatefulWidget {
  final UsersPageMode pageMode;

  const UsersPage({super.key, required this.pageMode});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final UsersLogic _logic = UsersLogic();

  void _navigateTo(User user) {
    switch (widget.pageMode) {
      case UsersPageMode.selectUser:
        navigatorKey.currentState?.pop(user);
        return;
      case UsersPageMode.userList:
      // TODO: navigate to detail user
    }
  }

  void _updateSearchText(String query) {
    _logic.searchKeywords = query;
    context.read<UsersBloc>().add(FetchUsersEvent(query: _logic.searchKeywords));
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingPage),
      child: RefreshIndicator(
        onRefresh: () async => context.read<UsersBloc>().add(FetchUsersEvent(query: _logic.searchKeywords)),
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
            BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                if (state is UsersLoadingState) {
                  return Expanded(
                    child: ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) => const CustomShimmer(),
                      separatorBuilder: (context, index) => const SizedBox(height: Dimens.paddingWidget),
                    ),
                  );
                } else if (state is UsersLoadedState) {
                  if (state.users.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (context, index) => UserRow(
                          user: state.users.elementAt(index),
                          onSelected: () => _navigateTo(state.users.elementAt(index)),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top: Dimens.paddingMedium),
                      child: Center(
                        child: Text(
                          "Tidak ada user.",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: ColorResources.warningText),
                        ),
                      ),
                    );
                  }
                } else {
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
    context.read<UsersBloc>().add(FetchUsersEvent(query: ""));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Users", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: _buildBody(),
    );
  }
}

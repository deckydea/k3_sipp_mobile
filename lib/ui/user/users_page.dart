import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/user/users_bloc.dart';
import 'package:k3_sipp_mobile/logic/user/users_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/group/user_group.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/model/user/user_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/util/message_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_search_field.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_shimmer.dart';
import 'package:k3_sipp_mobile/widget/progress_dialog.dart';
import 'package:k3_sipp_mobile/widget/user/user_row.dart';

enum UsersPageMode { selectUser, userList, multipleSelect }

class UsersPage extends StatefulWidget {
  final UsersPageMode pageMode;
  final UserFilter? filter;

  const UsersPage({super.key, required this.pageMode, this.filter});

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
        navigatorKey.currentState?.pushNamed("/update_user", arguments: user);
        return;
      case UsersPageMode.multipleSelect:
        _logic.selectedUsers.add(user);
        setState(() {});
        return;
    }
  }

  Future<void> _deleteUser(User user) async {
    if (widget.pageMode != UsersPageMode.userList) return;

    var result = await DialogUtils.showAlertDialog(
      context,
      dismissible: false,
      title: "Hapus Pengguna",
      content: "Apakah Anda yakin akan menghapus ${user.name} - ${user.nip}?",
      neutralAction: "Tidak",
      onNeutral: () => navigatorKey.currentState?.pop(false),
      negativeAction: "Hapus",
      onNegative: () => navigatorKey.currentState?.pop(true),
    );

    if (result == null || !result) return;

    if (mounted) {
      final ProgressDialog progressDialog = ProgressDialog("Loading", _logic.onDeleteUser(user.id!));
      MasterMessage message = await progressDialog.show();
      switch (message.response) {
        case MasterResponseType.success:
          if (mounted) {
            context.read<UsersBloc>().add(DeleteUserEvent(user.id!));
            await MessageUtils.showMessage(
              context: context,
              title: "Berhasil",
              content: "${user.name} - ${user.nip} berhasil dihapus",
              dialog: false,
            );
          }
          break;
        case MasterResponseType.notExist:
        case MasterResponseType.invalidCredential:
          if (mounted) DialogUtils.handleInvalidCredential(context);
          break;
        case MasterResponseType.invalidMessageFormat:
          if (mounted) DialogUtils.handleInvalidMessageFormat(context);
          break;
        case MasterResponseType.noConnection:
          if (mounted) DialogUtils.handleNoConnection(context);
          break;
        default:
          if (mounted) DialogUtils.handleException(context);
      }
    }
  }

  void _updateSearchText(String query) {
    _logic.searchKeywords = query;
    context.read<UsersBloc>().add(FetchUsersEvent(query: _logic.searchKeywords, userFilter: widget.filter));
  }

  Widget _buildGroups() {
    return Container(
      width: double.infinity,
      height: Dimens.cardGroupHeight,
      color: ColorResources.primaryDark,
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingPage),
      child: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          List<UserGroup> userGroups = context.read<UsersBloc>().usersGroups.toList();
          if (state is UsersLoadingState && userGroups.isEmpty) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) => const CustomShimmer(),
              separatorBuilder: (context, index) => const SizedBox(height: Dimens.paddingWidget),
            );
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              itemCount: userGroups.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) => CustomCard(
                color: Colors.white,
                child: Container(
                  width: Dimens.cardGroupWidth,
                  padding: const EdgeInsets.all(Dimens.paddingSmall),
                  child: Center(
                      child: Text(userGroups.elementAt(index).name,
                          softWrap: true, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium)),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildUsers() {
    return RefreshIndicator(
      onRefresh: () async =>
          context.read<UsersBloc>().add(FetchUsersEvent(query: _logic.searchKeywords, userFilter: widget.filter)),
      child: Column(
        children: [
          Visibility(
            visible: widget.pageMode == UsersPageMode.userList,
            child: _buildGroups(),
          ),
          const SizedBox(height: Dimens.paddingSmall),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
            child: CustomCard(
              child: CustomSearchField(
                key: _logic.searchKey,
                onFieldSubmitted: (value) async => _updateSearchText(value),
                onClearText: () {
                  _logic.searchKey.currentState?.clearText();
                  _updateSearchText("");
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
              child: BlocBuilder<UsersBloc, UsersState>(
                builder: (context, state) {
                  if (state is UsersLoadingState) {
                    return ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) => const CustomShimmer(),
                      separatorBuilder: (context, index) => const SizedBox(height: Dimens.paddingWidget),
                    );
                  } else if (state is UsersLoadedState) {
                    if (state.users.isNotEmpty) {
                      return ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          User user = state.users.elementAt(index);
                          return UserRow(
                            isSelected: _logic.selectedUsers.contains(user),
                            user: user,
                            onTap: () => _navigateTo(user),
                            onLongPress: () => _deleteUser(user),
                          );
                        },
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<UsersBloc>().add(FetchUsersEvent(query: "", userFilter: widget.filter));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Pengguna", style: Theme.of(context).textTheme.headlineLarge),
        actions: [
          widget.pageMode == UsersPageMode.multipleSelect
              ? TextButton(
                  onPressed: () => navigatorKey.currentState?.pop(_logic.selectedUsers),
                  child: Text("Simpan", style: Theme.of(context).textTheme.labelLarge),
                )
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigatorKey.currentState!.pushNamed("/create_user"),
        shape: const CircleBorder(),
        backgroundColor: ColorResources.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _buildUsers(),
    );
  }
}

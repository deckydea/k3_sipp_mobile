import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/user/user_row.dart';

class SelectUserPage extends StatefulWidget {
  final User? selectedUser;
  final List<User> users;
  const SelectUserPage({super.key, required this.users, this.selectedUser});

  @override
  State<SelectUserPage> createState() => _SelectUserPageState();
}

class _SelectUserPageState extends State<SelectUserPage> {
  User? _selectedUser;

  @override
  void initState() {
    super.initState();

    _selectedUser = widget.selectedUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Penanggungjawab", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(Dimens.paddingPage),
        itemCount: widget.users.length,
        itemBuilder: (context, index) {
          User user = widget.users.elementAt(index);
          return UserRow(
            isSelected: _selectedUser != null && _selectedUser!.id == user.id,
            user: user,
            onTap: () => navigatorKey.currentState?.pop(user),
          );
        },
      ),
    );
  }
}

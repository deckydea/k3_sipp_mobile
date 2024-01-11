import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/menu_cubit.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/repository/device_repository.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/ui/main/assignment_page.dart';
import 'package:k3_sipp_mobile/ui/main/home_page.dart';
import 'package:k3_sipp_mobile/ui/main/profile_page.dart';
import 'package:k3_sipp_mobile/ui/main/tools_page.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';

class MainMenuPage extends StatefulWidget {
  final User user;

  const MainMenuPage({super.key, required this.user});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {

  Widget _buildBottomNavigationBar() {
    return ConvexAppBar(
      backgroundColor: Colors.white,
      color: ColorResources.primaryDark,
      activeColor: ColorResources.iconActiveColor,
      style: TabStyle.react,
      items: const [
        TabItem(icon: Icons.home, title: "Home", isIconBlend: true),
        TabItem(icon: Icons.assignment, title: "Assignment", isIconBlend: true),
        TabItem(icon: Icons.computer, title: "Tools", isIconBlend: true),
        TabItem(icon: Icons.account_circle, title: "Profile", isIconBlend: true),
      ],
      onTap: (index) => context.read<MenuCubit>().navigateTo(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD MAIN MENU");
    return Scaffold(
      body: BlocBuilder<MenuCubit, int>(
        builder: (BuildContext context, state) => IndexedStack(
          index: state,
          children:  [
            HomePage(user: widget.user),
            const AssignmentPage(),
            const ToolsPage(),
            const ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/menu/menu_cubit.dart';
import 'package:k3_sipp_mobile/logic/menu/main_menu_logic.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/ui/main/assignment_page.dart';
import 'package:k3_sipp_mobile/ui/main/home_page.dart';
import 'package:k3_sipp_mobile/ui/main/menu_page.dart';
import 'package:k3_sipp_mobile/ui/main/profile_page.dart';
import 'package:k3_sipp_mobile/ui/main/template_pengujian_page.dart';

class MainMenuPage extends StatefulWidget {
  final User user;

  const MainMenuPage({super.key, required this.user});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  final MainMenuLogic _logic = MainMenuLogic();

  Future<void> _init() async {
    await _logic.init();
    _logic.initialized = true;
    setState(() {});
  }

  Widget _buildBottomNavigationBar() {
    return ConvexAppBar(
      backgroundColor: Colors.white,
      color: ColorResources.primaryDark,
      activeColor: ColorResources.iconActiveColor,
      style: TabStyle.react,
      items: const [
        TabItem(icon: Icons.home, title: "Home", isIconBlend: true),
        TabItem(icon: Icons.assignment, title: "Assignment", isIconBlend: true),
        TabItem(icon: Icons.menu_book, title: "Menu", isIconBlend: true),
        TabItem(icon: Icons.account_circle, title: "Profile", isIconBlend: true),
      ],
      onTap: (index) => context.read<MenuCubit>().navigateTo(index),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD MAIN MENU");

    if (!_logic.initialized) _init();
    return Scaffold(
      body: _logic.initialized
          ? BlocBuilder<MenuCubit, int>(
              builder: (BuildContext context, state) => IndexedStack(
                index: state,
                children: [
                  HomePage(user: widget.user),
                  const TemplatePengujianPage(),
                  const MenuPage(),
                  const ProfilePage(),
                ],
              ),
            )
          : Container(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}

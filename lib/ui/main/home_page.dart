import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/logic/menu/home_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeLogic _logic = HomeLogic();

  Future<void> _showLogoutDialog() async {
    var result = await DialogUtils.showAlertDialog(
      context,
      title: "Keluar",
      content: "Apakah Anda yakin ingin keluar?",
      onNeutral: () => Navigator.of(context).pop(false),
      onNegative: () => Navigator.of(context).pop(true),
      neutralAction: "Tidak",
      negativeAction: "Keluar",
    );

    if (result != null && result is bool && result) {
      //TODO: Clear repository etc
      AppRepository().logout();
      navigatorKey.currentState!.pushReplacementNamed("/login");
    }
  }

  Widget _buildUserTitle() {
    return Center(
      child: Column(
        children: [
          Text(
            _logic.user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, color: ColorResources.primaryDark, fontSize: Dimens.fontLarge),
          ),
          Text("NIP: ${_logic.user.nip}", style: const TextStyle(fontSize: Dimens.fontSmall, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({required String title, required IconData icon, required GestureTapCallback onTap}) {
    return ListTile(
      dense: true,
      title: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      leading: Icon(
        icon,
        color: ColorResources.primaryDark,
        size: Dimens.iconSize,
      ),
      onTap: onTap,
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      backgroundColor: ColorResources.backgroundDark,
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage),
        child: Column(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(Dimens.paddingSmall),
              child: Image.asset(
                'assets/drawable/logo.png',
                height: Dimens.logoSizeXLarge,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: Dimens.paddingWidget),
            _buildUserTitle(),
            const Expanded(child: SizedBox(height: Dimens.paddingPage)),
            _buildDrawerItem(
              title: "Keluar",
              icon: Icons.logout,
              onTap: () => _showLogoutDialog(),
            ),
            const SizedBox(height: Dimens.paddingPage),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _logic.init(user: widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sistem Pengujian", style: Theme.of(context).textTheme.headlineLarge),
                  Text("Balai K3 Bandung", style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ),
            Image.asset(
              'assets/drawable/logo.png',
              height: Dimens.logoXSizeSmall,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
      extendBody: true,
      drawer: _buildDrawer(),
      drawerScrimColor: ColorResources.backgroundDark,
      body: const Center(child: Text("Home")),
    );
  }
}

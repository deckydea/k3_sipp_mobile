import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_shimmer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _user;
  late ThemeData _themeData;
  bool _initialized = false;

  Future<void> _showLogoutDialog() async {
    var result = await DialogUtils.showAlertDialog(
      context,
      title: "Logout",
      content: "Apakah Anda yakin ingin logout?",
      onNeutral: () => Navigator.of(context).pop(false),
      onNegative: () => Navigator.of(context).pop(true),
      neutralAction: "Tidak",
      negativeAction: "Logout",
    );

    if (result != null && result is bool && result) {
      //TODO: Clear repository etc
      AppRepository().logout();
      navigatorKey.currentState!.pushReplacementNamed("/login");
    }
  }

  Future<void> _load() async {
    _user = (await AppRepository().getUser())!;
    _initialized = true;
    setState(() {});
  }

  Widget _buildGeneral() {
    return Container(
      // color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage + Dimens.paddingWidget, vertical: Dimens.paddingWidget),
      child: Column(
        children: [
          ListTile(
            shape: const Border(bottom: BorderSide(width: 1, color: Colors.black12)),
            leading: const Icon(
              Icons.privacy_tip,
              color: ColorResources.primaryDark,
              size: Dimens.iconSize,
            ),
            title: Text(
              "Privacy Policy",
              style: _themeData.textTheme.titleMedium?.copyWith(color: ColorResources.primaryDark, fontWeight: FontWeight.bold),
            ),
            trailing: GestureDetector(
              child: const Icon(
                Icons.keyboard_arrow_right_rounded,
                color: ColorResources.primaryDark,
                size: Dimens.iconSize,
              ),
            ),
          ),
          ListTile(
            shape: const Border(bottom: BorderSide(width: 1, color: Colors.black12)),
            leading: const Icon(
              Icons.my_library_books_outlined,
              color: ColorResources.primaryDark,
              size: Dimens.iconSize,
            ),
            title: Text(
              "Terms of Service",
              style: _themeData.textTheme.titleMedium?.copyWith(color: ColorResources.primaryDark, fontWeight: FontWeight.bold),
            ),
            trailing: GestureDetector(
              child: const Icon(
                Icons.keyboard_arrow_right_rounded,
                color: ColorResources.primaryDark,
                size: Dimens.iconSize,
              ),
            ),
          ),
          ListTile(
            shape: const Border(bottom: BorderSide(width: 1, color: Colors.black12)),
            leading: const Icon(
              Icons.perm_device_info,
              color: ColorResources.primaryDark,
              size: Dimens.iconSize,
            ),
            title: Text(
              "Version",
              style: _themeData.textTheme.titleMedium?.copyWith(color: ColorResources.primaryDark, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              "v 1.0.0",
              style: _themeData.textTheme.bodyMedium,
            ),
          ),
          ListTile(
            onTap: () => _showLogoutDialog(),
            shape: const Border(bottom: BorderSide(width: 1, color: Colors.black12)),
            leading: const Icon(
              Icons.logout_outlined,
              color: ColorResources.primaryDark,
              size: Dimens.iconSize,
            ),
            title: Text(
              "Logout",
              style: _themeData.textTheme.titleMedium?.copyWith(color: ColorResources.primaryDark, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Apa kamu yakin? Anda harus login lagi setelah Anda kembali.",
              style: _themeData.textTheme.bodySmall,
            ),
            trailing: const Icon(
              Icons.keyboard_arrow_right_rounded,
              color: ColorResources.primaryDark,
              size: Dimens.iconSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccount() {
    return Container(
      // color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage + Dimens.paddingWidget, vertical: Dimens.paddingWidget),
      child: Column(
        children: [
          ListTile(
            shape: const Border(bottom: BorderSide(width: 1, color: Colors.black12)),
            leading: const Icon(
              Icons.lock,
              color: ColorResources.primaryDark,
              size: Dimens.iconSize,
            ),
            title: Text(
              "Ubah Password",
              style: _themeData.textTheme.titleMedium?.copyWith(color: ColorResources.primaryDark, fontWeight: FontWeight.bold),
            ),
            trailing: GestureDetector(
              child: const Icon(
                Icons.keyboard_arrow_right_rounded,
                color: ColorResources.primaryDark,
                size: Dimens.iconSize,
              ),
            ),
          ),
          ListTile(
            shape: const Border(bottom: BorderSide(width: 1, color: Colors.black12)),
            leading: const Icon(
              Icons.language,
              color: ColorResources.primaryDark,
              size: Dimens.iconSize,
            ),
            title: Text(
              "Ubah Bahasa",
              style: _themeData.textTheme.titleMedium?.copyWith(color: ColorResources.primaryDark, fontWeight: FontWeight.bold),
            ),
            trailing: GestureDetector(
              child: const Icon(
                Icons.keyboard_arrow_right_rounded,
                color: ColorResources.primaryDark,
                size: Dimens.iconSize,
              ),
            ),
          ),
          ListTile(
            shape: const Border(bottom: BorderSide(width: 1, color: Colors.black12)),
            leading: const Icon(
              Icons.notifications_active,
              color: ColorResources.primaryDark,
              size: Dimens.iconSize,
            ),
            title: Text(
              "Notifikasi",
              style: _themeData.textTheme.titleMedium?.copyWith(color: ColorResources.primaryDark, fontWeight: FontWeight.bold),
            ),
            trailing: GestureDetector(
              child: const Icon(
                Icons.keyboard_arrow_right_rounded,
                color: ColorResources.primaryDark,
                size: Dimens.iconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingPage + Dimens.paddingWidget),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(Dimens.paddingWidget),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: ColorResources.primaryDark),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: Dimens.iconSizeMenu),
            ),
            title: Text(_user.name, style: _themeData.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(_user.username, style: _themeData.textTheme.titleSmall),
                Text(_user.nip, style: _themeData.textTheme.titleSmall),
              ],
            ),
            trailing: InkWell(
              onTap: () => navigatorKey.currentState?.pushNamed("/update_information_profile", arguments: _user),
              child: const Icon(Icons.edit, color: ColorResources.primaryDark),
            ),
          ),
        ),
        const SizedBox(height: Dimens.paddingLarge),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Dimens.paddingPage + Dimens.paddingWidget, vertical: Dimens.paddingWidget),
          child: Text("Akun", style: _themeData.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        ),
        _buildAccount(),
        const SizedBox(height: Dimens.paddingMedium),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Dimens.paddingPage + Dimens.paddingWidget, vertical: Dimens.paddingWidget),
          child: Text("General", style: _themeData.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        ),
        _buildGeneral(),
      ],
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.paddingPage),
      child: ListView.separated(
        physics: const ClampingScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) => const CustomShimmer(),
        separatorBuilder: (context, index) => const SizedBox(height: Dimens.paddingWidget),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: ColorResources.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Profile", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: !_initialized ? _buildShimmer() : _buildBody(),
    );
  }
}

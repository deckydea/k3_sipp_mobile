import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/net/request/request_type.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/widget/menu/menu_item.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final Map<String, MenuItem> _menus = {
    MasterRequestType.managementTemplate: MenuItem(
      title: "Template Pengujian",
      icon: Icons.assignment,
      onTap: () => navigatorKey.currentState?.pushNamed("/manage_template"),
    ),
    MasterRequestType.queryDevices: MenuItem(
      title: "Device/Tools",
      icon: Icons.devices,
      backgroundColor: Colors.teal,
      onTap: () => navigatorKey.currentState?.pushNamed("/devices"),
    ),
    MasterRequestType.queryCompanies: MenuItem(
      title: "Perusahan",
      icon: Icons.account_balance,
      backgroundColor: Colors.amber,
      onTap: () => navigatorKey.currentState?.pushNamed("/companies"),
    ),
    "Report": MenuItem(
      title: "Report",
      icon: Icons.pie_chart_outline,
      backgroundColor: Colors.deepOrangeAccent,
      onTap: () {},
    ),
    MasterRequestType.createUser: MenuItem(
      title: "User",
      icon: Icons.people_alt_outlined,
      backgroundColor: ColorResources.primaryDark,
      onTap: () => navigatorKey.currentState?.pushNamed("/users"),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Menu", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.paddingPage),
        child: ListView(children: _menus.values.map((menu) => menu).toList()),
      ),
    );
  }
}

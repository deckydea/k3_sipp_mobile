import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/res/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    print("BUILD ProfilePage");
    return Scaffold(
      backgroundColor: ColorResources.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Profile", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: SafeArea(
        child: Center(child: Text("Profile")),
      ),
    );
  }
}

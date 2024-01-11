import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/res/colors.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  @override
  Widget build(BuildContext context) {
    print("BUILD AssignmentPage");
    return Scaffold(
      backgroundColor: ColorResources.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Assignment", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: SafeArea(
        child: Center(child: Text("Assignment")),
      ),
    );
  }
}

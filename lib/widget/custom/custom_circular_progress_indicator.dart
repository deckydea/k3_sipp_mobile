import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/res/colors.dart';

class CustomCircularProgressIndicator extends StatefulWidget {
  const CustomCircularProgressIndicator({super.key});

  @override
  CustomCircularProgressIndicatorState createState() => CustomCircularProgressIndicatorState();
}

class CustomCircularProgressIndicatorState extends State<CustomCircularProgressIndicator> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<Color?>? animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = ColorTween(begin: ColorResources.primary, end: ColorResources.primaryDark).animate(controller!)
      ..addListener(() => setState(() {}));
    controller!.repeat();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: !kIsWeb && Platform.isIOS
          ? const CupertinoActivityIndicator(radius: 15)
          : CircularProgressIndicator(valueColor: animation, strokeWidth: 5),
    );
  }
}

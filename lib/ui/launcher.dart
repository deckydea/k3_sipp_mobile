import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/other/version_verification.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/settings_request.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/device_repository.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/res/localizations.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';
import 'package:k3_sipp_mobile/util/message_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Launcher extends StatefulWidget {
  const Launcher({super.key});

  @override
  LauncherState createState() => LauncherState();
}

class LauncherState extends State<Launcher> {
  late AppLocalizations _localizations;

  ///
  /// Check whether the app is safe to use.
  ///
  Future<void> _verifySecurity() async {
    // Check for jailbreak.
    bool jailbroken = await FlutterJailbreakDetection.jailbroken;
    if (jailbroken) {
      if (context.mounted) {
        await MessageUtils.showMessage(
          context: context,
          title: _localizations.translate("failed_jailbroken_title"),
          content: _localizations.translate("failed_jailbroken_message"),
          dialog: true,
        );
      }
      return;
    }

    // Check for developer mode.
    if (kReleaseMode && Platform.isAndroid) {
      bool developerMode = await FlutterJailbreakDetection.developerMode;
      if (developerMode) {
        if (context.mounted) {
          await MessageUtils.showMessage(
            context: context,
            title: _localizations.translate("failed_developer_mode_title"),
            content: _localizations.translate("failed_developer_mode_message"),
            dialog: true,
          );
        }
        return;
      }
    }

    _verifyVersion();
  }

  ///
  /// Check whether the app version is safe to use.
  ///
  Future<void> _verifyVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionNumber = packageInfo.version;
    int buildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;
    AppRepository().versionNumber = versionNumber;

    if (!TextUtils.isEmpty(versionNumber) && buildNumber > 0) {
      MasterMessage message = await ConnectionUtils.sendRequest(VerifyVersion());
      if (!TextUtils.isEmpty(message.token)) await AppRepository().setToken(message.token!);

      switch (message.response) {
        case MasterResponseType.success:
          _onVersionVerified();
          //TODO: Remove this
          // VersionVerification versionServer = VersionVerification.fromJson(jsonDecode(message.content!));
          // if (versionServer.buildNumber == buildNumber && TextUtils.equals(versionServer.versionNumber, versionNumber)) {
          //   // Safe to use, proceed to login
          //   _onVersionVerified();
          // } else {
          //   // The app is no longer valid
          //   if (context.mounted) {
          //     await MessageUtils.showMessage(
          //       context: context,
          //       title: _localizations.translate("invalid_version_title"),
          //       content: _localizations.translate("invalid_version_message"),
          //       dialog: true,
          //     );
          //   }
          //   SystemNavigator.pop();
          // }
          break;
        case MasterResponseType.noConnection:
          if (context.mounted) {
            await MessageUtils.showMessage(
              context: context,
              title: _localizations.translate("failed_no_connection_title"),
              content: _localizations.translate("failed_no_connection"),
              dialog: true,
            );
          }
          break;
        default:
          _onVersionVerified();
          //TODO: Remove this
          // The app is no longer valid
          // if (context.mounted) {
          //   await MessageUtils.showMessage(
          //     context: context,
          //     title: _localizations.translate("invalid_version_title"),
          //     content: _localizations.translate("invalid_version_message"),
          //     dialog: true,
          //   );
          // }
          // SystemNavigator.pop();
      }
    }
  }

  ///
  /// This method is called upon valid verification.
  /// There are 2 possibilities:
  /// 1. The device has already been registered but there is no logged in user yet, hence redirect to login,
  /// 2. The device has not been setup, hence redirect to setup page,
  ///
  Future<void> _onVersionVerified() async {
    User? user = await AppRepository().getUser();

    if (user != null) {
      navigatorKey.currentState?.pushReplacementNamed("/main_menu", arguments: user);
    } else {
      navigatorKey.currentState?.pushReplacementNamed("/login");
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize Notification.
    // NotificationUtils.initialize();
    // NotificationUtils.requestPermission();

    Future.delayed(const Duration(seconds: 1), () => _verifySecurity());
  }

  @override
  Widget build(BuildContext context) {
    _localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/launcher/foreground.png",
          width: Dimens.logoSizeLarge,
          height: Dimens.logoSizeLarge,
        ),
      ),
    );
  }
}

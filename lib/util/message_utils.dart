import "package:flutter/material.dart";
import "package:k3_sipp_mobile/main.dart";
import "package:k3_sipp_mobile/res/dimens.dart";
import "package:k3_sipp_mobile/res/localizations.dart";
import "package:k3_sipp_mobile/util/dialog_utils.dart";


class MessageUtils {
  static Future<void> showMessage(
      {required BuildContext context, String? title, required String content, bool dialog = false}) async {
    if (context.mounted && dialog) {
      // Show dialog.
      await DialogUtils.showAlertDialog(
        context,
        title: title ?? "",
        content: content,
      );
    } else {
      // Show snackbar.
      _showSnackbar(content);
    }
  }

  static void _showSnackbar(String text) {
    SnackBar snackBar = SnackBar(
      content: Text(text, style: const TextStyle(fontSize: Dimens.fontDefault, fontFamily: "Nunito")),
    );
    rootScaffoldMessengerKey.currentState?.removeCurrentSnackBar();
    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  static void handleInvalidAuthorization({required BuildContext context, required AppLocalizations localizations}) {
    if (context.mounted) {
      DialogUtils.handleInvalidAuthorization(context);
    } else {
      _showSnackbar(localizations.translate("failed_invalid_authorization"));
    }
  }

  static void handleNoConnection({required BuildContext context, required AppLocalizations localizations}) {
    if (context.mounted) {
      DialogUtils.handleNoConnection(context);
    } else {
      _showSnackbar(localizations.translate("failed_no_connection"));
    }
  }

  static void handleException({required BuildContext context, required AppLocalizations localizations}) {
    if (context.mounted) {
      DialogUtils.handleException(context);
    } else {
      _showSnackbar(localizations.translate("failed_exception"));
    }
  }

  static void handleInvalidMessageFormat({required BuildContext context, required AppLocalizations localizations}) {
    if (context.mounted) {
      DialogUtils.handleInvalidMessageFormat(context);
    } else {
      _showSnackbar(localizations.translate("failed_invalid_format"));
    }
  }

  static void handleInvalidSession() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil("/", (route) => false);
  }

  static void handleAccessDenied({required BuildContext context, required AppLocalizations localizations}) {
    if (context.mounted) {
      DialogUtils.handleAccessDenied(context);
    } else {
      _showSnackbar(localizations.translate("failed_access_denied"));
    }
  }

  static void handlePermissionDenied({required BuildContext context, required AppLocalizations localizations}) {
    if (context.mounted) {
      DialogUtils.handleAccessDenied(context);
    } else {
      _showSnackbar(localizations.translate("failed_permission_denied"));
    }
  }

  static void handleFeatureComingSoon(AppLocalizations localizations) {
    _showSnackbar(localizations.translate("common_feature_coming_soon"));
  }
}

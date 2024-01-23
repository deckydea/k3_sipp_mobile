import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/res/localizations.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';

class DialogUtils {
  static Future<dynamic> showAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
    String? positiveAction,
    String? negativeAction,
    String? neutralAction,
    Color titleColor = ColorResources.primaryDark,
    Color contentColor = Colors.black,
    Color positiveColor = Colors.green,
    Color negativeColor = Colors.red,
    Color neutralColor = Colors.black,
    VoidCallback? onPositive,
    VoidCallback? onNegative,
    VoidCallback? onNeutral,
    bool dismissible = true,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        titleTextStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(color: titleColor),
        contentTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: contentColor),
        actions: [
          if (!TextUtils.isEmpty(neutralAction))
            TextButton(
              onPressed: onNeutral,
              child: Text(neutralAction!.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(color: neutralColor)),
            ),
          if (!TextUtils.isEmpty(negativeAction))
            TextButton(
              onPressed: onNegative,
              child: Text(negativeAction!.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(color: negativeColor)),
            ),
          if (!TextUtils.isEmpty(positiveAction))
            TextButton(
              onPressed: onPositive,
              child: Text(positiveAction!.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(color: positiveColor)),
            ),
        ],
      ),
    );
  }

  static Future<dynamic> showOptionDialog({
    required BuildContext context,
    String? title,
    required List<String> options,
    List<IconData>? icons,
    required List<Function()> onSelected,
    bool? dismissible = true,
    List<Color>? color,
  }) async {
    return showDialog(
        context: context,
        barrierDismissible: dismissible!,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: TextUtils.isEmpty(title)
                  ? Container()
                  : Center(
                      child: Text(
                        title!,
                        style: const TextStyle(
                          fontSize: Dimens.fontLarge,
                          fontWeight: FontWeight.bold,
                          color: ColorResources.primaryDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
              children: options.map((option) {
                int index = options.indexOf(option);
                return SimpleDialogOption(
                    onPressed: onSelected.length <= index ? null : onSelected[index],
                    child: ListTile(
                    dense: true,
                    title: Text(
                      option,
                      style: TextStyle(
                        fontSize: Dimens.fontDefault,
                        color: color == null || color.length <= index
                            ? ColorResources.text
                            : color.elementAt(index),
                      ),
                    ),
                    leading: icons == null ||
                        icons.length <= index ||
                        icons.isEmpty
                        ? Container()
                        : Icon(icons.elementAt(index))
                  ),
                );
              }).toList());
        });
  }

  static Future<void> handleNoConnection(BuildContext context) async {
    String title = AppLocalizations.of(context).translate("failed_no_connection_title");
    String content = AppLocalizations.of(context).translate("failed_no_connection");
    String neutralAction = AppLocalizations.of(context).translate("action_ok").toUpperCase();
    await showAlertDialog(
      context,
      title: title,
      content: content,
      neutralAction: neutralAction,
      onNeutral: () => Navigator.of(context).pop(),
    );
  }

  static Future<void> handleInvalidMessageFormat(BuildContext context, {String? data}) async {
    String title = AppLocalizations.of(context).translate("failed_invalid_format_title");
    String content =
        "${AppLocalizations.of(context).translate("failed_invalid_format")}${TextUtils.isEmpty(data) ? "" : "\n\n$data"}";
    String neutralAction = AppLocalizations.of(context).translate("action_ok").toUpperCase();
    await showAlertDialog(
      context,
      title: title,
      content: content,
      neutralAction: neutralAction,
      onNeutral: () => Navigator.of(context).pop(),
    );
  }

  static Future<void> handleInvalidCredential(BuildContext context, {String? data}) async {
    String title = AppLocalizations.of(context).translate("failed_request");
    String content =
        "${AppLocalizations.of(context).translate("failed_invalid_credential")}${TextUtils.isEmpty(data) ? "" : "\n\n$data"}";
    String neutralAction = AppLocalizations.of(context).translate("action_ok").toUpperCase();
    await showAlertDialog(
      context,
      title: title,
      content: content,
      neutralAction: neutralAction,
      onNeutral: () => Navigator.of(context).pop(),
    );
  }

  static Future<void> handleInvalidAuthorization(BuildContext context) async {
    String title = AppLocalizations.of(context).translate("failed_request");
    String content = AppLocalizations.of(context).translate("failed_invalid_authorization");
    String neutralAction = AppLocalizations.of(context).translate("action_ok").toUpperCase();
    await showAlertDialog(
      context,
      title: title,
      content: content,
      neutralAction: neutralAction,
      onNeutral: () => Navigator.of(context).pop(),
    );
  }

  static Future<void> handleException(BuildContext context) async {
    String title = AppLocalizations.of(context).translate("failed_exception_title");
    String content = AppLocalizations.of(context).translate("failed_exception");
    String neutralAction = AppLocalizations.of(context).translate("action_ok").toUpperCase();
    await showAlertDialog(
      context,
      title: title,
      content: content,
      neutralAction: neutralAction,
      onNeutral: () => Navigator.of(context).pop(),
    );
  }

  static Future<void> handleInvalidSession(BuildContext context) async {
    String title = AppLocalizations.of(context).translate("failed_invalid_session_title");
    String content = AppLocalizations.of(context).translate("failed_invalid_session");
    String neutralAction = AppLocalizations.of(context).translate("action_ok").toUpperCase();
    await showAlertDialog(
      context,
      title: title,
      content: content,
      neutralAction: neutralAction,
      onNeutral: () => Navigator.of(context).pop(),
    );
    navigatorKey.currentState?.pushNamedAndRemoveUntil("/", (route) => false);
  }

  static Future<void> handleDuplicate(BuildContext context, {String? data}) async {
    String title = AppLocalizations.of(context).translate("failed_request");
    String content =
        "${AppLocalizations.of(context).translate("invalid_duplicate")}${TextUtils.isEmpty(data) ? "" : "\n\n$data"}";
    String neutralAction = AppLocalizations.of(context).translate("action_ok").toUpperCase();
    await showAlertDialog(
      context,
      title: title,
      content: content,
      neutralAction: neutralAction,
      onNeutral: () => Navigator.of(context).pop(),
    );
  }

  static Future<void> handleAccessDenied(BuildContext context) async {
    String title = AppLocalizations.of(context).translate("failed_access_denied_title");
    String content = AppLocalizations.of(context).translate("failed_access_denied");
    String neutralAction = AppLocalizations.of(context).translate("action_ok").toUpperCase();
    await showAlertDialog(
      context,
      title: title,
      content: content,
      neutralAction: neutralAction,
      onNeutral: () => Navigator.of(context).pop(),
    );
  }
}

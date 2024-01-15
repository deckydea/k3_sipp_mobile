import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';

class AppsProgressDialog {
  final BuildContext context;
  final String title;
  final Future<MasterMessage> logic;

  AppsProgressDialog(this.context, this.title, this.logic);

  Future<MasterMessage> show({bool showDialog = true}) async {
    MasterMessage message;
    try {
      if(showDialog) SmartDialog.showLoading(msg: title);
      message = await logic;
    } catch (e) {
      debugPrint('[AppsProgressDialog] error: $e');
      message = MasterMessage(response: MasterResponseType.exception, content: e.toString());
    } finally {
      if(showDialog) SmartDialog.dismiss();
    }
    return message;
  }
}
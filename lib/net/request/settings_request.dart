import 'dart:convert';

import 'package:k3_sipp_mobile/model/other/version_verification.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/request_type.dart';

class VerifyVersion extends MasterMessage {
  VerifyVersion(VersionVerification verification)
      : super(
    request: MasterRequestType.verifyVersion,
    content: jsonEncode(verification),
  );
}
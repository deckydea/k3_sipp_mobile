import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/request_type.dart';

class VerifyVersion extends MasterMessage {
  VerifyVersion() : super(request: MasterRequestType.verifyVersion, path: "utils/verify-version");
}

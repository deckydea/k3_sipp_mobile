import 'package:flutter/cupertino.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/user_request.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';

class LoginLogic {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<CustomButtonState> loginButtonKey = GlobalKey();
  bool passwordObscure = true;

  Future<void> init() async {}

  Future<void> onForgotPassword() async {}

  Future<MasterMessage> loginWithUsernamePassword() async {
    String username = usernameController.text;
    String password = passwordController.text;
    User user = User(username: username, password: password, name: '');
    MasterMessage message = MasterLoginRequest(user: user);
    return await ConnectionUtils.sendRequest(message);
  }
}

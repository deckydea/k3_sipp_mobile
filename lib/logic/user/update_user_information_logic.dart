
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/group/user_group.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/user_request.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';
import 'package:k3_sipp_mobile/util/image_utils.dart';

class UpdateUserInformationLogic {
  final GlobalKey<FormState> formKey = GlobalKey();

  final List<DropdownMenuItem<UserGroup>> dropdownUserGroups = [];

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController nipController = TextEditingController();
  final TextEditingController noSkpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  DateTime? birthDate;

  UserGroup? selectedGroup;
  Uint8List? signatureImage;

  bool isInitialized = false;
  bool obscure = true;

  Future<MasterMessage> onUpdate(User oldUser) async {
    if (formKey.currentState!.validate()) {
      User user = oldUser.replica;
      user.username = usernameController.text;
      user.userGroupId = selectedGroup!.id;
      user.password = md5.convert(utf8.encode(passwordController.text.trim())).toString();
      user.name = nameController.text;
      user.nip = nipController.text;
      user.noSKP = noSkpController.text;
      user.email = emailController.text;
      user.phone = phoneController.text;
      user.dateOfBirth = birthDate;

      if (signatureImage != null) user.signature = ImageUtils.encodeImage(signatureImage!);

      String? token = await AppRepository().getToken();
      return await ConnectionUtils.sendRequest(UpdateUserRequest(user: user, token: token));
    }

    return MasterMessage(response: MasterResponseType.invalidFormat);
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/logic/auth/login_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/device_repository.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/res/localizations.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/util/validator_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_edit_text.dart';
import 'package:k3_sipp_mobile/widget/progress_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginLogic _logic = LoginLogic();

  Future<void> _actionLogin() async {
    final ProgressDialog progressDialog = ProgressDialog(context, "Memproses Login", _logic.loginWithUsernamePassword());

    MasterMessage message = await progressDialog.show();
    if(!TextUtils.isEmpty(message.token)) await AppRepository().setToken(message.token!);
    switch (message.response) {
      case MasterResponseType.success:
        if (!TextUtils.isEmpty(message.content)) {
          User user = User.fromJson(jsonDecode(message.content!));
          AppRepository().setUser(user);
          navigatorKey.currentState!.pushReplacementNamed("/main_menu", arguments: user);
        }
        break;
      case MasterResponseType.notExist:
      case MasterResponseType.invalidCredential:
        if (mounted) DialogUtils.handleInvalidCredential(context);
        break;
      case MasterResponseType.pendingUser:
        if (mounted) {
          DialogUtils.showAlertDialog(
            context,
            title: AppLocalizations.of(context).translate("failed_request"),
            content: AppLocalizations.of(context).translate("failed_pending_user"),
          );
        }
        break;
      case MasterResponseType.accountLocked:
        if (mounted) {
          DialogUtils.showAlertDialog(
            context,
            title: AppLocalizations.of(context).translate("failed_request"),
            content: AppLocalizations.of(context).translate("failed_locked_user"),
          );
        }
        break;
      case MasterResponseType.invalidMessageFormat:
        if (mounted) DialogUtils.handleInvalidMessageFormat(context);
        break;
      case MasterResponseType.noConnection:
        if (mounted) DialogUtils.handleNoConnection(context);
        break;
      default:
        if (mounted) DialogUtils.handleException(context);
    }
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            'assets/drawable/raw.png',
            height: Dimens.logoSize,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: Dimens.paddingMedium),
        Text("Login", style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: Dimens.paddingSmall),
        Text("Selamat datang kembali di aplikasi", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: Dimens.paddingLarge),
        CustomEditText(
          width: double.infinity,
          label: "Username",
          controller: _logic.usernameController,
          icon: const Icon(Icons.account_circle_outlined, color: Colors.black45),
          validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
          textInputType: TextInputType.name,
        ),
        const SizedBox(height: Dimens.paddingSmall),
        StatefulBuilder(
          builder: (BuildContext context, insideState) {
            return CustomEditText(
              label: "Password",
              width: double.infinity,
              controller: _logic.passwordController,
              obscure: _logic.passwordObscure,
              validator: (value) => ValidatorUtils.validateMinInputLength(context, value, 6, required: true),
              icon: const Icon(Icons.lock_outline),
              textInputType: TextInputType.visiblePassword,
              onIconTap: () => insideState(() => _logic.passwordObscure = !_logic.passwordObscure),
            );
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: _logic.onForgotPassword,
            child: Text(
              "Lupa password?",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: Dimens.paddingMedium),
        CustomButton(
          minimumSize: const Size(double.infinity, Dimens.buttonHeightSmall),
          label: Text("Login", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
          backgroundColor: ColorResources.buttonBackground,
          onPressed: _actionLogin,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(Dimens.paddingPage),
        child: Form(
          key: _logic.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: Dimens.paddingMedium),
              _buildForm(),
              const SizedBox(height: Dimens.paddingSmall),
              const Center(
                child: Text(
                  '\u00a9 2024 Balai K3 Bandung Kemnaker',
                  style: TextStyle(color: ColorResources.primaryDark, fontSize: Dimens.fontSmall),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:k3_sipp_mobile/bloc/user/users_bloc.dart';
import 'package:k3_sipp_mobile/logic/user/user_logic.dart';
import 'package:k3_sipp_mobile/main.dart';
import 'package:k3_sipp_mobile/model/group/user_group.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/response/response_type.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/res/colors.dart';
import 'package:k3_sipp_mobile/res/dimens.dart';
import 'package:k3_sipp_mobile/ui/other/date_picker.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/dialog_utils.dart';
import 'package:k3_sipp_mobile/util/image_selection_utils.dart';
import 'package:k3_sipp_mobile/util/image_utils.dart';
import 'package:k3_sipp_mobile/util/message_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';
import 'package:k3_sipp_mobile/util/validator_utils.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_card.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_dialog.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_dropdown_button.dart';
import 'package:k3_sipp_mobile/widget/custom/custom_edit_text.dart';
import 'package:k3_sipp_mobile/widget/progress_dialog.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UserPage extends StatefulWidget {
  final User? user;

  const UserPage({super.key, this.user});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UserLogic _logic = UserLogic();

  Future<void> _actionCreate() async {
    final ProgressDialog progressDialog = ProgressDialog(context, "Memperbarui...", _logic.onCreate());

    MasterMessage message = await progressDialog.show();
    if (!TextUtils.isEmpty(message.token)) await AppRepository().setToken(message.token!);
    switch (message.response) {
      case MasterResponseType.success:
        if (!TextUtils.isEmpty(message.content)) {
          User user = User.fromJson(jsonDecode(message.content!));
          if (mounted) {
            context.read<UsersBloc>().add(AddUserEvent(user));
            await MessageUtils.showMessage(
              context: context,
              title: "Berhasil",
              content: "${user.name} berhasil ditambahkan",
            );
          }
          navigatorKey.currentState?.pop();
        }
        break;
      case MasterResponseType.notExist:
      case MasterResponseType.invalidCredential:
        if (mounted) DialogUtils.handleInvalidCredential(context);
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

  Future<void> _actionUpdate() async {
    final ProgressDialog progressDialog = ProgressDialog(context, "Memperbarui...", _logic.onUpdate(widget.user!));

    MasterMessage message = await progressDialog.show();
    if (!TextUtils.isEmpty(message.token)) await AppRepository().setToken(message.token!);
    switch (message.response) {
      case MasterResponseType.success:
        if (!TextUtils.isEmpty(message.content)) {
          User user = User.fromJson(jsonDecode(message.content!));
          if (mounted) {
            context.read<UsersBloc>().add(AddUserEvent(user));
            await MessageUtils.showMessage(
              context: context,
              title: "Berhasil",
              content: "${user.name} berhasil diubah",
            );
          }
          navigatorKey.currentState?.pop();
        }
        break;
      case MasterResponseType.notExist:
      case MasterResponseType.invalidCredential:
        if (mounted) DialogUtils.handleInvalidCredential(context);
        break;
      case MasterResponseType.invalidMessageFormat:
        if (mounted) DialogUtils.handleInvalidMessageFormat(context);
        break;
      case MasterResponseType.noConnection:
        if (mounted) DialogUtils.handleNoConnection(context);
        break;
      case MasterResponseType.invalidFormat:
        break;
      default:
        if (mounted) DialogUtils.handleException(context);
    }
  }

  Future<void> _getPicture() async {
    String? encodedImage = await ImageSelectionUtils.getImage(context);
    if (TextUtils.equals(encodedImage, ImageSelectionUtils.permissionDenied)) {
      if (mounted) MessageUtils.handlePermissionDenied(context: context);
      return;
    }

    if (!TextUtils.isEmpty(encodedImage)) {
      setState(() => _logic.signatureImage = ImageUtils.decodeImage(encodedImage));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now().toLocal();
    final DateTime minDate = now.subtract(const Duration(days: 200 * 365));
    final DateTime maxDate = now;

    DatePickerArgument argument = DatePickerArgument(
      mode: DateRangePickerSelectionMode.single,
      selectedDate: _logic.birthDate,
      minDate: minDate,
      maxDate: maxDate,
    );

    var result = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CustomDialog(
        width: Dimens.dialogWidthSmall,
        height: Dimens.dialogWidthSmall,
        child: DatePickerPage(argument: argument),
      ),
    );

    if (result != null && result is DateTime) {
      setState(() {
        _logic.birthDate = result;
        _logic.birthDateController.text = DateTimeUtils.formatToDate(result);
      });
    }
  }

  Future<void> _loadUserGroups() async {
    Set<UserGroup> userGroups = context.read<UsersBloc>().usersGroups;

    for (UserGroup userGroup in userGroups) {
      _logic.dropdownUserGroups.add(DropdownMenuItem(value: userGroup, child: Text(userGroup.name)));

      if (widget.user != null && widget.user!.userGroup!.id == userGroup.id) {
        _logic.selectedGroup = userGroup;
      }
    }

    _logic.selectedGroup ??= userGroups.first;
    _logic.isInitialized = true;
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.paddingPage),
        child: Form(
          key: _logic.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomEditText(
                width: double.infinity,
                label: "Username",
                controller: _logic.usernameController,
                icon: const Icon(Icons.person, color: ColorResources.primaryDark, size: Dimens.iconSize),
                validator: (value) => ValidatorUtils.validateUsername(context, value),
                textInputType: TextInputType.name,
              ),
              const SizedBox(height: Dimens.paddingSmall),
              StatefulBuilder(
                builder: (BuildContext context, insideState) {
                  return CustomDropdownButton(
                    items: _logic.dropdownUserGroups,
                    value: _logic.selectedGroup,
                    width: double.infinity,
                    onChanged: (value) => value != null ? insideState(() => _logic.selectedGroup = value) : null,
                  );
                },
              ),
              const SizedBox(height: Dimens.paddingSmall),
              StatefulBuilder(
                builder: (BuildContext context, insideState) {
                  return CustomEditText(
                    width: double.infinity,
                    label: "Password",
                    controller: _logic.passwordController,
                    icon: const Icon(Icons.lock, color: ColorResources.primaryDark, size: Dimens.iconSize),
                    onIconTap: () => insideState(() => _logic.obscure = !_logic.obscure),
                    validator: (value) => ValidatorUtils.validatePassword(context, value),
                    textInputType: TextInputType.text,
                    obscure: _logic.obscure,
                  );
                },
              ),
              const SizedBox(height: Dimens.paddingSmall),
              StatefulBuilder(
                builder: (BuildContext context, insideState) {
                  return CustomEditText(
                    width: double.infinity,
                    label: "Ulangi Password",
                    controller: _logic.repeatPasswordController,
                    icon: const Icon(Icons.lock, color: ColorResources.primaryDark, size: Dimens.iconSize),
                    onIconTap: () => insideState(() => _logic.obscure = !_logic.obscure),
                    validator: (value) => ValidatorUtils.validateRepeatPassword(context, _logic.passwordController.text, value),
                    textInputType: TextInputType.text,
                    obscure: _logic.obscure,
                  );
                },
              ),
              const SizedBox(height: Dimens.paddingSmall),
              const Divider(),
              const SizedBox(height: Dimens.paddingSmall),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingGap),
                child: Text(
                  "Informasi Profile",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: Dimens.paddingSmall),
              CustomEditText(
                width: double.infinity,
                label: "Nama",
                controller: _logic.nameController,
                icon: const Icon(Icons.account_circle, color: ColorResources.primaryDark, size: Dimens.iconSize),
                validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
                textInputType: TextInputType.name,
              ),
              const SizedBox(height: Dimens.paddingSmall),
              CustomEditText(
                width: double.infinity,
                label: "NIP",
                controller: _logic.nipController,
                icon: const Icon(Icons.card_membership, color: ColorResources.primaryDark, size: Dimens.iconSize),
                validator: (value) => ValidatorUtils.validateNotEmpty(context, value),
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: Dimens.paddingSmall),
              CustomEditText(
                width: double.infinity,
                label: "Tanggal Lahir",
                controller: _logic.birthDateController,
                readOnly: true,
                cursorVisible: false,
                icon: Icon(TextUtils.isEmpty(_logic.birthDateController.text) ? Icons.calendar_month : Icons.cancel_outlined),
                onIconTap:
                    !TextUtils.isEmpty(_logic.birthDateController.text) ? () => _logic.birthDateController.text = "" : null,
                onTap: () => _selectDate(context),
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: Dimens.paddingSmall),
              CustomEditText(
                width: double.infinity,
                label: "Email",
                controller: _logic.emailController,
                icon: const Icon(Icons.email, color: ColorResources.primaryDark, size: Dimens.iconSize),
                validator: (value) => ValidatorUtils.validateEmail(context, value),
                textInputType: TextInputType.name,
              ),
              const SizedBox(height: Dimens.paddingSmall),
              CustomEditText(
                width: double.infinity,
                label: "No. Telepon",
                controller: _logic.phoneController,
                icon: const Icon(Icons.phone, color: ColorResources.primaryDark, size: Dimens.iconSize),
                validator: (value) => ValidatorUtils.validatePhone(context, value),
                textInputType: TextInputType.name,
              ),
              const SizedBox(height: Dimens.paddingSmall),
              const Divider(),
              const SizedBox(height: Dimens.paddingSmall),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingGap),
                child: Text(
                  "Tanda Tangan",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: Dimens.paddingSmall),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingGap),
                child: GestureDetector(
                  onTap: _getPicture,
                  child: Container(
                    height: MediaQuery.of(context).size.width * 9 / 16,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: ColorResources.primaryDark,
                      borderRadius: BorderRadius.circular(Dimens.cardRadius),
                    ),
                    child: _logic.signatureImage == null
                        ? Icon(
                            Icons.add_a_photo,
                            color: Colors.grey[200],
                            size: Dimens.logoSize,
                          )
                        : CustomCard(child: Image.memory(_logic.signatureImage!, fit: BoxFit.cover)),
                  ),
                ),
              ),
              const SizedBox(height: Dimens.paddingMedium),
              CustomButton(
                minimumSize: const Size(double.infinity, Dimens.buttonHeightSmall),
                label: Text("Simpan", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
                backgroundColor: ColorResources.primary,
                onPressed: _logic.isUpdate ? _actionUpdate : _actionCreate,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      _logic.isUpdate = true;
      _logic.usernameController.text = widget.user!.username;
      _logic.nameController.text = widget.user!.name;
      _logic.nipController.text = widget.user!.nip;
      _logic.emailController.text = widget.user!.email ?? "";
      _logic.phoneController.text = widget.user!.phone ?? "";
      if (widget.user!.dateOfBirth != null) {
        _logic.birthDateController.text = DateTimeUtils.formatToDate(widget.user!.dateOfBirth!);
        _logic.birthDate = widget.user!.dateOfBirth;
      }
      if (widget.user!.signature != null) {
        _logic.signatureImage = ImageUtils.decodeImage(widget.user!.signature);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _logic.usernameController.dispose();
    _logic.nameController.dispose();
    _logic.nipController.dispose();
    _logic.phoneController.dispose();
    _logic.emailController.dispose();
    _logic.birthDateController.dispose();
    _logic.passwordController.dispose();
    _logic.repeatPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_logic.isInitialized) _loadUserGroups();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorResources.primaryDark),
        backgroundColor: ColorResources.background,
        title: Text("Informasi Akun", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: _buildBody(),
    );
  }
}

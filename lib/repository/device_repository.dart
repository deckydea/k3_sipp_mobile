import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:k3_sipp_mobile/model/user/user.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';

class DeviceRepository {
  static const String _userKey = "USER";
  static const String _tokenKey = "TOKEN";

  static final DeviceRepository _instance = DeviceRepository._internal();

  factory DeviceRepository() => _instance;

  DeviceRepository._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String? _versionNumber;
  User? _user;
  String? _token;

  String? get versionNumber => _versionNumber;

  set versionNumber(versionNumber) => _versionNumber = versionNumber;

  Future<String?> getToken() async {
    if (TextUtils.isEmpty(_token)) {
      String? result = await _secureStorage.read(key: _tokenKey);
      if (!TextUtils.isEmpty(result)) _token = result;
    }

    return _token;
  }

  Future<void> setToken(String token) async {
    if(!TextUtils.isEmpty(token)){
      _token = token;
      await _secureStorage.write(key: _tokenKey, value: _token);
    }
  }

  ///
  /// This method is to check if it's user already registered or not
  ///
  Future<bool> get isRegistered async {
    // Create storage
    if (_user == null) await getUser();
    return _user != null;
  }

  Future<User?> getUser() async {
    if (_user == null) {
      String? result = await _secureStorage.read(key: _userKey);
      if (!TextUtils.isEmpty(result)) {
        _user = User.fromJson(jsonDecode(result!));
      }
    }

    return _user;
  }

  Future<void> setUser(User value) async {
    _user = value;
    await _secureStorage.write(key: _userKey, value: jsonEncode(_user));
  }

  Future<void> logout() async {
    _user = null;
    await _secureStorage.delete(key: _userKey);
  }
}

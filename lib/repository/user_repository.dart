import 'package:k3_sipp_mobile/model/user/user.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();

  factory UserRepository() => _instance;

  UserRepository._internal();

  // A map to cache transaction details with their system log number as the key.
  final Map<int, User> _users = {};
}

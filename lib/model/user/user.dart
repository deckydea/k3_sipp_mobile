import 'dart:convert';

import 'package:k3_sipp_mobile/model/group/user_group.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';

class User {
  static Comparator<User> get nameComparator => (user1, user2) => user1.name.toLowerCase().compareTo(user2.name.toLowerCase());

  static Comparator<User> get usernameComparator =>
      (user1, user2) => user1.username.toLowerCase().compareTo(user2.username.toLowerCase());

  int? id;
  String username;
  String? password;
  String name;
  String nip;
  String? signature;
  DateTime? dateOfBirth;
  String? email;
  String? phone;
  DateTime? createdAt;
  DateTime? updatedAt;

  // Access
  int? userGroupId;
  String? userGroupName;
  UserGroup? userGroup;

  User({
    this.id,
    required this.username,
    this.password,
    required this.name,
    required this.nip,
    this.signature,
    this.dateOfBirth,
    this.email,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.userGroupId,
    this.userGroupName,
    this.userGroup,
  });

  String get firstName => TextUtils.isEmpty(name) ? "" : name.split(" ")[0];

  String get initial => TextUtils.isEmpty(name) ? "" : name[0].toUpperCase();

  User get replica => User(
        id: id,
        username: username,
        password: password,
        name: name,
        nip: nip,
        signature: signature,
        dateOfBirth: dateOfBirth,
        email: email,
        phone: phone,
        userGroupId: userGroupId,
        userGroupName: userGroupName,
        userGroup: userGroup,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'username': username,
        if (password != null) 'password': password,
        'name': name,
        'nip': nip,
        if (signature != null) 'signature': signature,
        if (dateOfBirth != null) 'dateOfBirth': DateTimeUtils.format(dateOfBirth!),
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (userGroup != null) "userGroup": userGroup,
        if (userGroupId != null) "userGroupId": userGroupId,
        if (userGroupName != null) "userGroupName": userGroupName,
        if (createdAt != null) 'createdAt': DateTimeUtils.format(createdAt!),
        if (updatedAt != null) 'updatedAt': DateTimeUtils.format(updatedAt!),
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      name: json['name'],
      nip: json['nip'],
      signature: json['signature'],
      dateOfBirth: json['dateOfBirth'] == null ? null : DateTime.parse(json['dateOfBirth']).toLocal(),
      email: json['email'],
      phone: json['phone'],
      userGroupId: json['userGroupId'],
      userGroupName: json['userGroupName'],
      userGroup: json['userGroup'] == null ? null : UserGroup.fromJson(json["userGroup"]),
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']).toLocal(),
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']).toLocal(),
    );
  }
}

// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';

enum UserGroupStatus { ACTIVE, VOID }

class UserGroup extends Equatable{
  static Comparator<UserGroup> get nameComparator => (a, b) {
        return TextUtils.equals(a.name, "ADMIN")
            ? -1
            : TextUtils.equals(b.name, "ADMIN")
                ? 1
                : a.name.toLowerCase().compareTo(b.name.toLowerCase());
      };

  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Set<String> userAccessMenus;

  const UserGroup({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.userAccessMenus,
  });

  bool get isAdmin => TextUtils.equals(name, "ADMIN");

  String getInitials(int numWords) {
    if (TextUtils.isEmpty(name) || numWords <= 0) return "";
    List<String> words = name.split(RegExp(r"\s+"));
    StringBuffer stringBuffer = StringBuffer();
    int maxLength = min(words.length, numWords);
    for (int i = 0; i < maxLength; i++) {
      String word = words[i].replaceAll(RegExp(r"\[\(\)\]"), "");
      if (!TextUtils.isEmpty(word)) {
        if (i != 0) {
          stringBuffer.write(" ");
        }
        stringBuffer.write(word[0].toUpperCase());
      }
    }
    return stringBuffer.toString();
  }

  UserGroup get replica {
    Set<String> userAccessMenuReplica = {};
    userAccessMenuReplica.addAll(userAccessMenus);
    return UserGroup(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userAccessMenus: userAccessMenuReplica,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createdAt": DateTimeUtils.format(createdAt),
        "updatedAt": DateTimeUtils.format(updatedAt),
        "userAccessMenus": userAccessMenus.toList(),
      };

  factory UserGroup.fromJson(Map<String, dynamic> json) {
    Set<String> userAccessMenus = {};
    if (json["userAccessMenus"] != null) {
      Iterable iterable = json["userAccessMenus"];
      for (var accessMenu in iterable) {
        userAccessMenus.add(accessMenu);
      }
    }
    return UserGroup(
      id: json["id"],
      name: json["name"],
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
      userAccessMenus: userAccessMenus,
    );
  }

  @override
  List<Object?> get props => [id, name, createdAt, updatedAt, userAccessMenus];
}

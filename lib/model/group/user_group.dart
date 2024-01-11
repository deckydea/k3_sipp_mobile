// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:k3_sipp_mobile/util/date_time_utils.dart';
import 'package:k3_sipp_mobile/util/text_utils.dart';

enum UserGroupStatus { ACTIVE, VOID }

class UserGroup {
  static Comparator<UserGroup> get nameComparator => (a, b) {
        return TextUtils.equals(a.name, "ADMIN")
            ? -1
            : TextUtils.equals(b.name, "ADMIN")
                ? 1
                : a.name.toLowerCase().compareTo(b.name.toLowerCase());
      };

  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  Set<String> userAccessMenu;

  UserGroup({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.userAccessMenu,
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
    userAccessMenuReplica.addAll(userAccessMenu);
    return UserGroup(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userAccessMenu: userAccessMenuReplica,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createdAt": DateTimeUtils.format(createdAt),
        "updatedAt": DateTimeUtils.format(updatedAt),
        "userAccessMenu": userAccessMenu.toList(),
      };

  factory UserGroup.fromJson(Map<String, dynamic> json) {
    Set<String> userAccessMenu = {};
    if (json["userAccessMenu"] != null) {
      Iterable iterable = json["userAccessMenu"];
      for (var accessMenu in iterable) {
        userAccessMenu.add(accessMenu);
      }
    }
    return UserGroup(
      id: json["id"],
      name: json["name"],
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
      userAccessMenu: userAccessMenu,
    );
  }
}

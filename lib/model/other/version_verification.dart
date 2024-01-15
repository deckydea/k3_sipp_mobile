// ignore_for_file: constant_identifier_names


class VersionVerification {
  String versionNumber;
  int buildNumber;

  VersionVerification({this.versionNumber = "0", this.buildNumber = 0});

  Map<String, dynamic> toJson() => {
        "versionNumber": versionNumber,
        "buildNumber": buildNumber,
      };

  factory VersionVerification.fromJson(Map<String, dynamic> json) {
    return VersionVerification(
      versionNumber: json["versionNumber"],
      buildNumber: int.parse(json["buildNumber"]),
    );
  }
}

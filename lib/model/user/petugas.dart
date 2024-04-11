import 'package:k3_sipp_mobile/model/user/user.dart';

class Petugas {
  int petugasId;
  bool penanggungJawab;
  User? user;

  Petugas({required this.petugasId, required this.penanggungJawab, this.user});

  Map<String, dynamic> toJson() => {
        'petugasId': petugasId,
        'penanggungJawab': penanggungJawab,
        'PetugasTemplate': user,
      };

  Petugas.fromJson(Map<String, dynamic> json)
      : petugasId = json['petugasId'],
        penanggungJawab = json['penanggungJawab'],
        user = User.fromJson(json['PetugasTemplate']);
}

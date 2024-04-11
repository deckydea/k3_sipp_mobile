class Company {
  int? id;
  String companyName;
  String? companyAddress;
  String? contactName;
  String? contactNumber;
  String? picName;

  Company({this.id, required this.companyName, this.companyAddress, this.contactName, this.contactNumber, this.picName});

  // Create a replica of the current Company object
  Company replica() => Company(
        id: id,
        companyName: companyName,
        companyAddress: companyAddress,
        contactName: contactName,
        contactNumber: contactNumber,
        picName: picName,
      );

  // Convert Company object to JSON data
  Map<String, dynamic> toJson() => {
        'id': id,
        'company_name': companyName,
        'company_address': companyAddress,
        'contactName': contactName,
        'contactNumber': contactNumber,
        'PICName': picName,
      };

  // Convert JSON data to a Company object
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      companyName: json['company_name'],
      companyAddress: json['company_address'],
      contactName: json['contactName'],
      contactNumber: json['contactNumber'],
      picName: json['PICName'],
    );
  }
}

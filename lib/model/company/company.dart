class Company{
  int? id;
  String? companyName;
  String? companyAddress;

  Company({this.id, this.companyName, this.companyAddress});

  // Create a replica of the current Company object
  Company replica() => Company(
      id: id,
      companyName: companyName,
      companyAddress: companyAddress,
    );

  // Convert Company object to JSON data
  Map<String, dynamic> toJson() => {
      'id': id,
      'companyName': companyName,
      'companyAddress': companyAddress,
    };


  // Convert JSON data to a Company object
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      companyName: json['company_name'],
      companyAddress: json['company_address'],
    );
  }

}
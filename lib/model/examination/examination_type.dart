class ExaminationType {
  final int id;
  final String name;
  final String description;

  ExaminationType({required this.id, required this.name, required this.description});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory ExaminationType.fromJson(Map<String, dynamic> json) {
    return ExaminationType(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class Device {
  int? id;
  String? name;
  String? description;
  double? calibrationValue;
  double? u95;
  double? coverageFactor;
  String? note;

  Device({
    this.id,
    this.name,
    this.description,
    this.calibrationValue,
    this.u95,
    this.coverageFactor,
    this.note,
  });

  // Create a replica (clone) of the Tool instance
  Device get replica => Device(
        id: id,
        name: name,
        description: description,
        calibrationValue: calibrationValue,
        u95: u95,
        coverageFactor: coverageFactor,
        note: note,
      );

  // Convert a Tool instance to a JSON object
  Map<String, dynamic> toJson() => {
        if(id != null) 'id': id,
        if(name != null) 'name': name,
        if(description != null) 'description': description,
        if(calibrationValue != null) 'calibrationValue': calibrationValue,
        if(u95 != null) 'u95': u95,
        if(coverageFactor != null) 'coverageFactor': coverageFactor,
        if(note != null) 'note': note,
      };

  // Create a Tool instance from a JSON object
  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      calibrationValue: json['calibrationValue']?.toDouble(),
      u95: json['u95']?.toDouble(),
      coverageFactor: json['coverageFactor']?.toDouble(),
      note: json['note'],
    );
  }
}

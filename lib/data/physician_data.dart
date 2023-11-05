class PhysicianData {
  final String prefix;
  final String name;
  final String department;
  final String disease;
  final String medication;
  final String hospital;

  PhysicianData({
    required this.prefix,
    required this.name,
    required this.department,
    required this.disease,
    required this.medication,
    required this.hospital,
  });

  factory PhysicianData.fromJson(Map<String, dynamic> json) {
    return PhysicianData(
      prefix: json['prefix'].toString(),
      name: json['name'].toString(),
      department: json['department'].toString(),
      disease: json['disease'].toString(),
      medication: json['medication'].toString(),
      hospital: json['hospital'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'prefix': prefix,
      'name': name,
      'department': department,
      'disease': disease,
      'medication': medication,
      'hospital': hospital,
    };
  }
}

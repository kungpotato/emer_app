class EducationData {
  EducationData({
    required this.hospital,
    required this.departure,
    required this.role,
  });

  factory EducationData.fromJson(Map<String, dynamic> json) {
    return EducationData(
      hospital: json['hospital'] as String,
      departure: json['departure'] as String,
      role: json['role'] as String,
    );
  }

  final String hospital;
  final String departure;
  final String role;

  Map<String, dynamic> toMap() {
    return {
      'hospital': hospital,
      'departure': departure,
      'role': role,
    };
  }
}

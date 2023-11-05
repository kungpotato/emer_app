class WorkAddressData {
  WorkAddressData({
    required this.hospital,
    required this.departure,
    required this.role,
  });

  factory WorkAddressData.fromJson(Map<String, dynamic> json) {
    return WorkAddressData(
      hospital: json['hospital'].toString(),
      departure: json['departure'].toString(),
      role: json['role'].toString(),
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

class MedicalHistory {
  final String chronic;
  final String current;
  final String allergic;

  MedicalHistory({
    required this.chronic,
    required this.current,
    required this.allergic,
  });

  factory MedicalHistory.fromJson(Map<String, dynamic> json) {
    return MedicalHistory(
      chronic: json['chronic'].toString(),
      current: json['current'].toString(),
      allergic: json['allergic'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chronic': chronic,
      'current': current,
      'allergic': allergic,
    };
  }
}

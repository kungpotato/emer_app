import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emer_app/data/medical_history_data.dart';
import 'package:emer_app/data/physician_data.dart';

class HealthInfoData {
  final String hospital1;
  final String hospital2;
  final String phone1;
  final String phone2;
  final MedicalHistory medicalHistory;
  final List<PhysicianData> physicians;
  final DocumentReference? ref;
  final String? id;

  HealthInfoData(
      {required this.hospital1,
      required this.hospital2,
      required this.phone1,
      required this.phone2,
      required this.medicalHistory,
      required this.physicians,
      this.id,
      this.ref});

  factory HealthInfoData.fromJson(Map<String, dynamic> json) {
    return HealthInfoData(
      hospital1: json['hospital1'].toString(),
      hospital2: json['hospital2'].toString(),
      phone1: json['phone1'].toString(),
      phone2: json['phone2'].toString(),
      medicalHistory: MedicalHistory.fromJson(
          json['medicalHistory'] as Map<String, dynamic>),
      id: json['id'].toString(),
      ref: json['ref'] as DocumentReference?,
      physicians: (json['physicians'] as List)
          .map((physicianJson) =>
              PhysicianData.fromJson(physicianJson as Map<String, dynamic>))
          .toList(), // Deserialize a list of PhysicianData from JSON
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hospital1': hospital1,
      'hospital2': hospital2,
      'phone1': phone1,
      'phone2': phone2,
      'medicalHistory': medicalHistory.toMap(),
      'physicians': physicians.map((physician) => physician.toMap()).toList(),
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class UserInsuranceData {
  final String policyNumber;
  final String name;
  final String surname;
  final String coverageType;
  final Timestamp start;
  final Timestamp end;
  final String? agentName;
  final String? agentNumber;
  final String? cardUrl;
  final String company;
  final DocumentReference? ref;
  final String? id;
  final String? img;

  UserInsuranceData({
    required this.policyNumber,
    required this.name,
    required this.surname,
    required this.coverageType,
    required this.start,
    required this.end,
    required this.agentName,
    required this.agentNumber,
    this.cardUrl,
    this.img,
    required this.company,
    this.id,
    this.ref,
  });

  factory UserInsuranceData.fromJson(Map<String, dynamic> json) {
    return UserInsuranceData(
      policyNumber: json['policyNumber'] as String,
      name: json['name'] as String,
      company: json['company'] as String,
      surname: json['surname'] as String,
      coverageType: json['coverageType'] as String,
      start: json['start'] as Timestamp,
      end: json['end'] as Timestamp,
      agentName: json['agentName'] as String?,
      agentNumber: json['agentNumber'] as String?,
      cardUrl: json['cardUrl'] as String?,
      id: json['id'].toString(),
      img: json['img']?.toString(),
      ref: json['ref'] as DocumentReference?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'policyNumber': policyNumber,
      'name': name,
      'surname': surname,
      'coverageType': coverageType,
      'start': start,
      'end': end,
      'agentName': agentName,
      'agentNumber': agentNumber,
      'cardUrl': cardUrl,
      'img': img,
      'company': company,
    };
  }
}

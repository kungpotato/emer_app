import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceData {
  final String name;
  final String zoneName;
  final GeoPoint? location;

  DeviceData({required this.name, required this.zoneName, this.location});

  factory DeviceData.fromJson(Map<String, dynamic> json) {
    return DeviceData(
      name: json['name'] as String,
      zoneName: json['zoneName'] as String,
      location: json['location'] != null
          ? GeoPoint(
              (json['location']['latitude'] as num).toDouble(),
              (json['location']['longitude'] as num).toDouble(),
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'zoneName': zoneName,
      'location': location != null
          ? {
              'latitude': location!.latitude,
              'longitude': location!.longitude,
            }
          : null,
    };
  }
}

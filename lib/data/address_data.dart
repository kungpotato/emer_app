import 'package:cloud_firestore/cloud_firestore.dart';

class AddressData {
  AddressData({
    required this.address,
    required this.district,
    required this.province,
    required this.postcode,
    required this.country,
    this.location,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) {
    return AddressData(
      address: json['address'] as String,
      district: json['district'] as String,
      province: json['province'] as String,
      postcode: json['postcode'] as String,
      country: json['country'] as String,
      location: json['location'] != null
          ? GeoPoint(
              (json['location']['latitude'] as num).toDouble(),
              (json['location']['longitude'] as num).toDouble(),
            )
          : null,
    );
  }

  String address;
  String district;
  String province;
  String postcode;
  String country;
  GeoPoint? location;

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'district': district,
      'province': province,
      'postcode': postcode,
      'country': country,
      'location': location != null
          ? {
              'latitude': location!.latitude,
              'longitude': location!.longitude,
            }
          : null,
    };
  }
}

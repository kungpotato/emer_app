import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emer_app/core/exceptions/app_error_hadler.dart';
import 'package:emer_app/data/address_data.dart';
import 'package:emer_app/data/education_data.dart';
import 'package:emer_app/data/work_adrress_data.dart';

enum ProfileRole { user, doctor }

class ProfileData {
  ProfileData(
      {required this.role,
      required this.name,
      this.idCard,
      this.namePrefix,
      this.birthday,
      this.height,
      this.weight,
      this.blood,
      this.img,
      this.address,
      this.workAddress,
      this.email,
      this.id,
      this.ref,
      this.verify,
      this.education,
      this.contact,
      this.members = const [],
      this.assistant = false});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    try {
      return ProfileData(
          id: json['id']?.toString(),
          email: json['email']?.toString(),
          idCard: json['idCard'].toString(),
          ref: json['ref'] as DocumentReference?,
          role: json['role'].toString() == 'user'
              ? ProfileRole.user
              : ProfileRole.doctor,
          name: json['name'].toString(),
          birthday: json['birthday'] as Timestamp?,
          height: json["height"] as String?,
          weight: json["weight"] as String?,
          blood: json['blood'].toString(),
          img: json['img']?.toString(),
          verify: json['verify'] as bool?,
          address: json['address'] != null
              ? AddressData.fromJson(json['address'] as Map<String, dynamic>)
              : null,
          workAddress: json['workAddress'] != null
              ? WorkAddressData.fromJson(
                  json['workAddress'] as Map<String, dynamic>,
                )
              : null,
          education: json['education'] != null
              ? EducationData.fromJson(
                  json['education'] as Map<String, dynamic>,
                )
              : null,
          contact: json['contact'] != null
              ? ContactInfo.fromMap(
                  json['contact'] as Map<String, dynamic>,
                )
              : null,
          members: ((json['members'] ?? <Map<String, dynamic>>[]) as List)
              .map((e) => MemberData.fromJson(e as Map<String, dynamic>))
              .toList(),
          assistant: (json['assistant'] ?? false) as bool,
          namePrefix: json['namePrefix']?.toString());
    } catch (err, st) {
      handleError(err, st);
      rethrow;
    }
  }

  final ProfileRole role;
  final String? idCard;
  final String? namePrefix;
  final String name;
  final Timestamp? birthday;
  final String? height;
  final String? weight;
  final String? blood;
  final String? img;
  final AddressData? address;
  final WorkAddressData? workAddress;
  final String? email;
  final String? id;
  final DocumentReference? ref;
  final bool? verify;
  final EducationData? education;
  final ContactInfo? contact;
  final bool assistant;
  final List<MemberData> members;

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role.name,
      'name': name,
      'namePrefix': namePrefix,
      'idCard': idCard,
      'birthday': birthday,
      'height': height,
      'weight': weight,
      'blood': blood,
      'img': img,
      'address': address?.toMap(),
      'workAddress': workAddress?.toMap(),
      'education': education?.toMap(),
      'verify': verify,
      'contact': contact?.toMap(),
      'assistant': assistant,
      'members': members..map((e) => e.toMap()),
    };
  }
}

class ContactInfo {
  final String phone;
  final String? email;

  ContactInfo({required this.phone, this.email});

  factory ContactInfo.fromMap(Map<String, dynamic> map) {
    return ContactInfo(
      phone: map['phone'].toString(),
      email: map['email']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'email': email,
    };
  }
}

class MemberData {
  final String id;
  final String name;
  final String imgUrl;
  GeoPoint location;

  MemberData(
      {required this.id,
      required this.name,
      required this.imgUrl,
      required this.location});

  factory MemberData.fromJson(Map<String, dynamic> json) {
    return MemberData(
      id: json['id'] as String,
      name: json['name'] as String,
      imgUrl: json['imgUrl'] as String,
      location: json['location'] != null
          ? GeoPoint(
              (json['location']['latitude'] as num).toDouble(),
              (json['location']['longitude'] as num).toDouble(),
            )
          : GeoPoint(13.813289, 100.5633786),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imgUrl': imgUrl,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
    };
  }
}

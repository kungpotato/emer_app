import 'dart:async';
import 'dart:convert';

import 'package:emer_app/app/services/firestore_ref.dart';
import 'package:emer_app/core/exceptions/app_error_hadler.dart';
import 'package:emer_app/data/health_info_data.dart';
import 'package:emer_app/data/profile_data.dart';
import 'package:emer_app/data/province_thai_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';

part 'auth_store.g.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  userInfo,
  verify,
  verifyEmail
}

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  final auth = FirebaseAuth.instance;

  @observable
  AuthStatus status = AuthStatus.unknown;

  @observable
  bool loading = false;

  @observable
  User? user;

  @observable
  ProfileData? profile;

  @action
  void setStatus(AuthStatus st) => status = st;

  @action
  void setLoading(bool val) => loading = val;

  @action
  void setUSer(User? data) => user = data;

  @action
  void setProfile(ProfileData? data) => profile = data;

  void setAuthenticateState() => setStatus(AuthStatus.authenticated);

  void setSignOutState() => setStatus(AuthStatus.unauthenticated);

  void setUserInfoState() => setStatus(AuthStatus.userInfo);

  void setVerifyState() => setStatus(AuthStatus.verify);

  void setVerifyEmailState() => setStatus(AuthStatus.verifyEmail);

  // @action
  // void setDbUser(UserModel val) => dbUser = val;

  // Future<UserModel?> getDbUser(User user) async {
  //   final uri = Uri.parse(
  //     '${FlavorConfig.instance.variables["baseUrl"]}${APIEnPoint.getUserProfileByEmail}',
  //   ).replace(
  //     queryParameters: {
  //       'language': 'th',
  //       'email': user.email,
  //     },
  //   );
  //   try {
  //     final token = await AppConfig.getToken(user.email ?? '');
  //
  //     final response =
  //     await http.get(uri, headers: {'Authorization': 'Bearer $token'});
  //     if (response.statusCode == 200) {
  //       final list = jsonDecode(response.body) as List?;
  //       final employees = list
  //           ?.map((e) => UserModel.fromMap(e as Map<String, dynamic>))
  //           .toList() ??
  //           [];
  //       if (employees.isNotEmpty) {
  //         setDbUser(employees.first);
  //         return employees.first;
  //       } else {
  //         throw EmployeeException(
  //           message: 'Failed to get employee profile email ${user.email}',
  //         );
  //       }
  //     } else {
  //       throw GetProfileException(
  //         message:
  //         'Failed to load profile : status code ${response.statusCode}',
  //       );
  //     }
  //   } catch (err, st) {
  //     handleError(err, st);
  //   }
  //   return null;
  // }

  Future<void> register(String email, String password) async {
    setLoading(true);
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (err, st) {
      handleError(err, st);
      setLoading(false);
    }
  }

  Future<void> login(String email, String password) async {
    setLoading(true);
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (err, st) {
      handleError(err, st);
      setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    setLoading(true);
    try {
      await auth.signInWithProvider(GoogleAuthProvider());
    } catch (err, st) {
      handleError(err, st);
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    setSignOutState();
    setLoading(false);
  }

  Stream<ProfileData?> getDbProfile(User user) {
    return FsRef.profileRef
        .where('email', isEqualTo: user.email)
        .snapshots()
        .map((event) {
      if (event.size > 0) {
        final e = event.docs.first;
        return ProfileData.fromJson(
          {'id': e.id, 'ref': e.reference, ...e.data()},
        );
      } else {
        return null;
      }
    });
  }

  Stream<HealthInfoData?> getHealthInfo(String id) {
    return FsRef.health(id).snapshots().map((event) {
      if (event.size > 0) {
        final e = event.docs.first;
        return HealthInfoData.fromJson(
          {'id': e.id, 'ref': e.reference, ...e.data()},
        );
      } else {
        return null;
      }
    });
  }

  Future<List<ProvinceThaiData>> fetchProvince() async {
    const url =
        'https://raw.githubusercontent.com/kungpotato/provinceThai/main/provinceThai.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        return list
            .map((e) => ProvinceThaiData.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        print(
          'Failed to load Tambon info. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Failed to load Tambon info. Error: $e');
    }
    return <ProvinceThaiData>[];
  }
}

import 'package:flutter/foundation.dart';

abstract class Failure {
  Failure(this.message);

  final String message;
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class CacheFailure extends Failure {
  CacheFailure(super.message);
}

class GetProfileException implements Exception {
  GetProfileException({this.message});

  final String? message;
}

class EmployeeException implements Exception {
  EmployeeException({this.message});

  final String? message;
}

class NetworkException implements Exception {
  NetworkException({this.message});

  final String? message;
}

void handleError(dynamic e, [StackTrace? st]) {
  if (kDebugMode) {
    print(e);
  }
  debugPrintStack(stackTrace: st);
}

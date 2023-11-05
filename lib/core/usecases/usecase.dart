import 'package:dartz/dartz.dart';
import 'package:emer_app/core/exceptions/app_error_hadler.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}

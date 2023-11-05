import 'package:emer_app/app/authentication/store/auth_store.dart';
import 'package:emer_app/app/locale/locale_store.dart';
import 'package:provider/provider.dart';

class StoreInitializers {
  factory StoreInitializers() {
    return _instance;
  }

  StoreInitializers._internal();

  static final StoreInitializers _instance = StoreInitializers._internal();

  static StoreInitializers get instance => _instance;

  Future<void> setup() async {}

  List<Provider<dynamic>> get providers => [
        Provider<LocaleStore>.value(value: LocaleStore()),
        Provider<AuthStore>.value(value: AuthStore()),
      ];
}

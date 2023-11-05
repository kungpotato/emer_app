import 'dart:ui';

import 'package:mobx/mobx.dart';

part 'locale_store.g.dart';

class LocaleStore = LocaleStoreBase with _$LocaleStore;

abstract class LocaleStoreBase with Store {
  @observable
  Locale locale = const Locale('th');

  @action
  void changeLocale(Locale newLocale) {
    locale = newLocale;
  }
}

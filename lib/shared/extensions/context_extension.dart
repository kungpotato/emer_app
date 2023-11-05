import 'package:emer_app/app/authentication/store/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  void hideKeyBoard() => FocusScope.of(this).unfocus();

  AuthStore get authStore => Provider.of<AuthStore>(this, listen: false);
}

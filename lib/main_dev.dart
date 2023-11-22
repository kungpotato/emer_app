import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:emer_app/app/app.dart';
import 'package:emer_app/app/initailizer/app_initializer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storeInitializers = StoreInitializers.instance;
  await storeInitializers.setup();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(
    MultiProvider(
      providers: storeInitializers.providers,
      child: App(
        adaptiveThemeMode: savedThemeMode,
      ),
    ),
  );
}

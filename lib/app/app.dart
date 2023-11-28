import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:emer_app/app/app_home.dart';
import 'package:emer_app/app/authentication/login_page.dart';
import 'package:emer_app/app/authentication/splash_page.dart';
import 'package:emer_app/app/authentication/store/auth_store.dart';
import 'package:emer_app/app/locale/locale_store.dart';
import 'package:emer_app/app/services/firebase_messaging_service.dart';
import 'package:emer_app/app/storage/theme_storeage.dart';
import 'package:emer_app/app/theme/app_theme.dart';
import 'package:emer_app/core/exceptions/app_error_hadler.dart';
import 'package:emer_app/l10n/l10n.dart';
import 'package:emer_app/pages/no_internet_page.dart';
import 'package:emer_app/pages/pin_verify_page.dart';
import 'package:emer_app/pages/user_profile_form_page.dart';
import 'package:emer_app/pages/verify_email_page.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:emer_app/shared/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';

class App extends StatefulWidget {
  const App({this.adaptiveThemeMode, super.key});

  final AdaptiveThemeMode? adaptiveThemeMode;

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _auth = FirebaseAuth.instance;

  late ReactionDisposer disposer;
  StreamSubscription<dynamic>? subAuth;
  StreamSubscription<dynamic>? subFcm;
  late StreamSubscription<dynamic> subConnect;

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    super.initState();
    ThemePreferences.instance.init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      subFcm = FirebaseMessagingService.instance.onRefreshToken().listen((tk) {
        context.authStore.profile?.ref!.update({'fcm': tk});
      });
      subConnect = Connectivity().onConnectivityChanged.listen((result) {
        if (result == ConnectivityResult.none) {
          subAuth?.cancel();
          context.authStore.setDisConnectState();
        } else {
          watchUser();
        }
      });
      watchAuthState();
      await FirebaseMessagingService.instance.initialize(_navigator);
    });
  }

  void watchUser() {
    subAuth = _auth.authStateChanges().switchMap((user) {
      if (user != null) {
        context.authStore.setUSer(user);
        return context.authStore.getDbProfile(user).flatMap((dbUser) {
          if (dbUser != null) {
            context.authStore.setProfile(dbUser);
            return context.authStore.getHealthInfo(dbUser.id!).flatMap((info) {
              return Stream.fromFuture(FirebaseMessaging.instance.getToken())
                  .flatMap((value) => Stream.fromFuture(dbUser.fcm.isEmpty
                          ? dbUser.ref!.update({'fcm': value ?? ''})
                          : Future.value(dbUser))
                      .map((event) => info));
            }).flatMap((info) {
              // if (dbUser.verify != true &&
              //     dbUser.role == ProfileRole.doctor) {
              //   context.authStore.setVerifyState();
              // } else
              if (info != null) {
                if (user.emailVerified) {
                  context.authStore.setAuthenticateState();
                } else {
                  context.authStore.setVerifyEmailState();
                }
              }
              return Stream.value(dbUser);
            });
          }
          context.authStore.setProfile(null);
          context.authStore.setUserInfoState();
          return Stream.value(null);
        });
      } else {
        context.authStore.setSignOutState();
        return Stream.value(null);
      }
    }).listen((user) {
      //
    }, onError: (dynamic err) {
      if (mounted) {
        showSnack(context, text: err.toString());
        handleError(err);
      }
    });
  }

  void watchAuthState() {
    final authStore = Provider.of<AuthStore>(context, listen: false);
    disposer = reaction(
      (_) => authStore.status,
      (status) {
        if (status == AuthStatus.noInternet) {
          _navigator.pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (context) => const NoInternetPage(),
            ),
            (route) => false,
          );
        } else if (status == AuthStatus.unauthenticated) {
          _navigator.pushAndRemoveUntil(
            MaterialPageRoute<dynamic>(
              builder: (context) => const LoginPage(),
            ),
            (route) => false,
          );
        } else if (status == AuthStatus.userInfo) {
          _navigator.pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (context) => const UserProfileFormPage(),
            ),
            (route) => false,
          );
        } else if (status == AuthStatus.verify) {
          _navigator.push(
            MaterialPageRoute<void>(
              builder: (context) => const PinVerifyPage(),
            ),
          );
        } else if (status == AuthStatus.verifyEmail) {
          _navigator.pushAndRemoveUntil(
            MaterialPageRoute<dynamic>(
              builder: (context) => VerifyEmailPage(),
            ),
            (route) => false,
          );
        } else if (status == AuthStatus.authenticated) {
          _navigator.pushAndRemoveUntil(
            MaterialPageRoute<dynamic>(
              builder: (context) => const AppHome(),
            ),
            (route) => false,
          );
        }
      },
      onError: (err, _) {
        handleError(err);
        showSnack(context, text: err.toString());
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    disposer.call();
    subAuth?.cancel();
    subConnect.cancel();
    subFcm?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final localeStore = Provider.of<LocaleStore>(context, listen: false);

    return AdaptiveTheme(
      light: MyThemes.lightTheme,
      dark: MyThemes.darkTheme,
      initial: widget.adaptiveThemeMode ?? AdaptiveThemeMode.light,
      builder: (light, dark) => Observer(
        builder: (context) => ReactiveFormConfig(
          validationMessages: {
            ValidationMessage.required: (error) => 'Should not be empty',
            ValidationMessage.email: (error) => 'Invalid email',
          },
          child: MaterialApp(
            title: 'My App',
            theme: light,
            darkTheme: dark,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('th'),
              Locale('en'),
            ],
            locale: localeStore.locale,
            navigatorKey: _navigatorKey,
            onGenerateRoute: (settings) =>
                MaterialPageRoute(builder: (context) => const SplashPage()),
          ),
        ),
      ),
    );
  }
}

import 'package:emer_app/app/theme/app_appbar.dart';
import 'package:emer_app/app/theme/app_color.dart';
import 'package:emer_app/shared/helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final inputDecoration = InputDecorationTheme(
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade200),
    borderRadius: const BorderRadius.all(Radius.circular(40)),
  ),
  focusColor: AppColors.primary,
  filled: true,
  isDense: true,
  labelStyle: TextStyle(color: Colors.black87, fontSize: 14),
  hintStyle: TextStyle(color: Colors.black87, fontSize: 14),
  fillColor: AppColors.background,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(40),
    borderSide: BorderSide(color: Colors.grey.shade200),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(40),
    borderSide: BorderSide(color: Colors.grey.shade200),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(40),
    borderSide: BorderSide(color: Colors.red),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(40),
    borderSide: BorderSide(color: Colors.red),
  ),
  outlineBorder: BorderSide(color: Colors.grey.shade200),
  prefixStyle: TextStyle(color: AppColors.primary),
  prefixIconColor: Colors.grey,
);

class MyThemes {
  static final lightTheme = ThemeData(
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        background: AppColors.background,
      ),
      primaryColor: AppColors.primary,
      primarySwatch: colorToMaterialColor(AppColors.primary),
      fontFamily: GoogleFonts.prompt(fontStyle: FontStyle.normal).fontFamily,
      brightness: Brightness.light,
      appBarTheme: AppAppbar.appbar,
      scaffoldBackgroundColor: AppColors.background,
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.primary),
        ),
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.black54),
        titleMedium: TextStyle(color: Colors.black54),
        titleSmall: TextStyle(color: Colors.black54),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: inputDecoration,
      textSelectionTheme:
          TextSelectionThemeData(cursorColor: AppColors.primary),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.background,
        headerBackgroundColor: AppColors.primary,
        todayBorder: BorderSide(
          color: AppColors.primary,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold),
          foregroundColor: AppColors.primary,
        ),
      ),
      dropdownMenuTheme:
          DropdownMenuThemeData(inputDecorationTheme: inputDecoration));

  static final darkTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    fontFamily: GoogleFonts.prompt(fontStyle: FontStyle.normal).fontFamily,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor:
          Colors.blueGrey, // Set AppBar background color for dark theme
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colorToMaterialColor(
        Colors.blueGrey,
      ), // Set the desired color for CircularProgressIndicator here
    ),
  );
}

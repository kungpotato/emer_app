import 'package:emer_app/app/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppAppbar {
  static final appbar = AppBarTheme(
    backgroundColor: AppColors.background,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(
      color: AppColors.primary,
    ),
    titleTextStyle: TextStyle(
      color: AppColors.primary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.prompt(fontStyle: FontStyle.normal).fontFamily,
    ),
  );
}

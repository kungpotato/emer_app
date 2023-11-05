import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Color hexToColor(String hexColorCode) {
  if (hexColorCode.startsWith('#')) {
    hexColorCode = hexColorCode.substring(1);
  }

  if (hexColorCode.length != 6 && hexColorCode.length != 8) {
    throw ArgumentError('Invalid HEX color code format');
  }

  if (hexColorCode.length == 6) {
    hexColorCode = 'FF$hexColorCode';
  }

  return Color(int.parse('0x$hexColorCode'));
}

MaterialColor colorToMaterialColor(Color color) {
  final strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (var i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (final strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

void showSnack(BuildContext context, {required String text, Color? color}) {
  final snackBar = SnackBar(
    content: Text(text),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}

DateTime parseDate(String dateString) {
  List<String> parts = dateString.split('-');

  if (parts.length != 3) {
    throw FormatException(
        'The provided date string does not match the format dd-MM-yyyy');
  }

  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int year = int.parse(parts[2]);

  return DateTime(year, month, day);
}

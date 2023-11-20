import 'dart:convert';
import 'dart:isolate';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

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

Future<bool?> confirmBackForm(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('Confirm'),
      content: new Text(
          'Do you want to go back? Any changes you made will not be saved.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: new Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: new Text('Yes'),
        ),
      ],
    ),
  );
}

Future<void> hrLoadImage(ImageData imageData) async {
  final response = await http.get(Uri.parse(imageData.imageUrl));
  imageData.sendPort.send(response.bodyBytes);
}

Future<Uint8List> getNetworkImageMarker({
  String? imageUrl,
  String? base64Image,
  double diameter = 150,
  Color circleColor = Colors.white,
  String? text,
}) async {
  Uint8List? response;
  if (imageUrl?.isNotEmpty ?? false) {
    final receivePort = ReceivePort();

    await Isolate.spawn(
      hrLoadImage,
      ImageData(receivePort.sendPort, imageUrl!),
    );
    response = await receivePort.first as Uint8List;
  } else {
    final ByteData data = await rootBundle.load('assets/images/pindrop.png');
    response = data.buffer.asUint8List();
  }

  final codec = await ui.instantiateImageCodec(
    (base64Image?.isNotEmpty ?? false) ? base64Decode(base64Image!) : response,
  );
  final frame = await codec.getNextFrame();
  final image = frame.image;

  // Create a PictureRecorder
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final canvas = ui.Canvas(pictureRecorder);

  // Draw the circle
  final circlePaint = Paint()..color = circleColor;
  canvas.drawCircle(
    Offset(diameter / 2, diameter / 2),
    diameter / 2,
    circlePaint,
  );

  // Clip the image to a circle
  final imageSize = diameter * 0.85;
  final src =
      Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble());
  final dst = Rect.fromLTWH(
    (diameter - imageSize) / 2,
    (diameter - imageSize) / 2,
    imageSize,
    imageSize,
  );

  if ((imageUrl?.isNotEmpty ?? false) || (base64Image?.isNotEmpty ?? false)) {
    final clipPath = Path()..addOval(dst);
    canvas.clipPath(clipPath);
  }

  // Draw the image
  canvas.drawImageRect(image, src, dst, Paint());

  if (text != null && text.isNotEmpty) {
    final textStyle = ui.TextStyle(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.bold, // Font weight (can be changed)
    );
    final paragraphStyle = ui.ParagraphStyle(
      textAlign: TextAlign.center,
      maxLines: 1,
    );
    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(text);

    final constraints = ui.ParagraphConstraints(width: diameter);
    final paragraph = paragraphBuilder.build()..layout(constraints);

    // Calculate the offset to position the text at the bottom of the image
    final offset = Offset(
      0,
      diameter - paragraph.height - 5.0,
    ); // 5.0 is a padding value, can be adjusted
    canvas.drawParagraph(paragraph, offset);
  }

  // Get the recorded picture as bytes
  final picture = pictureRecorder.endRecording();
  final img = await picture.toImage(diameter.toInt(), diameter.toInt());
  final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
  return bytes!.buffer.asUint8List();
}

Future<String> _networkImageToBase64(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final bytes = response.bodyBytes;
    final base64Image = base64Encode(bytes);
    return base64Image;
  } else {
    throw Exception('Failed to load network image.');
  }
}

Future<String> getBase64Image(String url) async {
  return _networkImageToBase64(url);
}

class ImageData {
  ImageData(this.sendPort, this.imageUrl);

  final SendPort sendPort;
  final String imageUrl;
}

import 'package:flutter/material.dart';

enum CustomAppBarShape { wave, roundLeft, roundRight, roundBoth, shark }

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    required this.title,
    this.shape = CustomAppBarShape.wave,
    super.key,
    this.actions,
  });

  final CustomAppBarShape? shape;
  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(shape: shape),
      child: Container(
        padding: const EdgeInsets.only(right: 15), // Add padding if needed
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.orange],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  // Add padding if needed
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (actions != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions!,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  MyClipper({this.shape});

  final CustomAppBarShape? shape;

  @override
  Path getClip(Size size) {
    if (shape == CustomAppBarShape.roundLeft) {
      return _roundLeft(size);
    } else if (shape == CustomAppBarShape.roundRight) {
      return _roundRight(size);
    } else if (shape == CustomAppBarShape.roundBoth) {
      return _roundBoth(size);
    } else if (shape == CustomAppBarShape.shark) {
      return _shark(size);
    }
    return _waveShape(size);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

Path _roundLeft(Size size) {
  final path = Path();
  path.moveTo(0, size.height * 0.2);
  path.quadraticBezierTo(0, 0, size.width * 0.2, 0);
  path.lineTo(size.width, 0);
  path.lineTo(size.width, size.height);
  path.lineTo(size.width * 0.2, size.height);
  path.quadraticBezierTo(0, size.height, 0, size.height * 0.8);
  path.close();

  return path;
}

Path _roundRight(Size size) {
  final path = Path();
  path.lineTo(size.width * 0.8, 0);
  path.quadraticBezierTo(size.width, 0, size.width, size.height * 0.2);
  path.lineTo(size.width, size.height * 0.8);
  path.quadraticBezierTo(
    size.width,
    size.height,
    size.width * 0.8,
    size.height,
  );
  path.lineTo(0, size.height);
  path.close();

  return path;
}

Path _roundBoth(Size size) {
  final path = Path();
  path.moveTo(0, size.height * 0.2);
  path.quadraticBezierTo(0, 0, size.width * 0.2, 0);
  path.lineTo(size.width * 0.8, 0);
  path.quadraticBezierTo(size.width, 0, size.width, size.height * 0.2);
  path.lineTo(size.width, size.height * 0.8);
  path.quadraticBezierTo(
    size.width,
    size.height,
    size.width * 0.8,
    size.height,
  );
  path.lineTo(size.width * 0.2, size.height);
  path.quadraticBezierTo(0, size.height, 0, size.height * 0.8);
  path.close();

  return path;
}

Path _waveShape(Size size) {
  final path = Path();
  path.lineTo(0, size.height - 30);

  final firstControlPoint = Offset(size.width / 4, size.height);
  final firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
  path.quadraticBezierTo(
    firstControlPoint.dx,
    firstControlPoint.dy,
    firstEndPoint.dx,
    firstEndPoint.dy,
  );

  final secondControlPoint =
      Offset(size.width - (size.width / 3.25), size.height - 65);
  final secondEndPoint = Offset(size.width, size.height - 40);
  path.quadraticBezierTo(
    secondControlPoint.dx,
    secondControlPoint.dy,
    secondEndPoint.dx,
    secondEndPoint.dy,
  );

  path.lineTo(size.width, 0);
  path.close();

  return path;
}

Path _shark(Size size) {
  final path = Path();
  path.lineTo(0, size.height - 20);

  const totalTeeth = 10; // You can adjust this for more or less teeth
  final teethWidth = size.width / totalTeeth;
  const teethHeight = 20.0;

  for (var i = 0; i < totalTeeth; ++i) {
    path.relativeLineTo(teethWidth / 2, teethHeight);
    path.relativeLineTo(teethWidth / 2, -teethHeight);
  }

  path.lineTo(size.width, size.height - 20);
  path.lineTo(size.width, 0);
  path.close();

  return path;
}

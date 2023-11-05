import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class BottomNavCustom extends StatelessWidget {
  const BottomNavCustom({
    required this.selectedIndex,
    required this.onItemTap,
    super.key,
  });

  final int selectedIndex;
  final void Function(int) onItemTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 70,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -3), // changes position of shadow
            ),
          ],
        ),
        child: ClipPath(
          clipper: _MyClipper(),
          child: BottomAppBar(
            height: 50,
            color: context.theme.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () => onItemTap(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/image 7.png',
                        height: 30,
                        color:
                            selectedIndex == 0 ? Colors.black87 : Colors.white,
                      ),
                      Text(
                        'HOME',
                        style: context.theme.textTheme.labelMedium?.copyWith(
                          color: selectedIndex == 0
                              ? Colors.black87
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => onItemTap(1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Group.png',
                        height: 30,
                        color: selectedIndex == 1 ? Colors.black87 : null,
                      ),
                      Text(
                        'MEMBER',
                        style: context.theme.textTheme.labelMedium?.copyWith(
                          color: selectedIndex == 1
                              ? Colors.black87
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => onItemTap(2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Group.png',
                        height: 30,
                        color: selectedIndex == 2 ? Colors.black87 : null,
                      ),
                      Text(
                        'DEVICE',
                        style: context.theme.textTheme.labelMedium?.copyWith(
                          color: selectedIndex == 2
                              ? Colors.black87
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => onItemTap(3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Vector2.png',
                        height: 30,
                        color: selectedIndex == 3 ? Colors.black87 : null,
                      ),
                      Text(
                        'PROFILE',
                        style: context.theme.textTheme.labelMedium?.copyWith(
                          color: selectedIndex == 3
                              ? Colors.black87
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    const double radius = 20;

    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);

    path.lineTo(0, radius);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

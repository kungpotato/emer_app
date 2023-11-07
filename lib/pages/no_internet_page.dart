import 'package:emer_app/shared/widget/no_internet_widget.dart';
import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: context.theme.primaryColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset('assets/images/shape.png'),
          ),
          Center(
            child: NoInternetWidget(
              message: 'No internet connection.\nPlease check your connection.',
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:emer_app/shared/widget/success_widget.dart';
import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

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
            child: SuccessWidget(
              message: 'Your operation was successful!',
              onPressed: () {
                context.authStore.setAuthenticateState();
              },
            ),
          ),
        ],
      ),
    );
  }
}

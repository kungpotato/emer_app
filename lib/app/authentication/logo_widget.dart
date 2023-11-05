import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'LIFELINK',
      style: context.theme.textTheme.headlineLarge?.copyWith(
        color: color ?? context.theme.primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

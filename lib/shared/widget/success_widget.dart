import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({
    required this.message,
    super.key,
    this.onPressed,
  });

  final String message;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 100,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: context.theme.textTheme.titleLarge,
          ),
          if (onPressed != null) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(
                'OK',
                style: context.theme.textTheme.labelLarge
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

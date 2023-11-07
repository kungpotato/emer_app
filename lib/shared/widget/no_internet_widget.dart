import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({
    required this.message,
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.signal_wifi_statusbar_connected_no_internet_4,
            color: Colors.red,
            size: 100,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.theme.textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

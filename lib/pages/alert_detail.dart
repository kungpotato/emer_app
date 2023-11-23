import 'dart:async';

import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:emer_app/shared/widget/video_widget.dart';
import 'package:flutter/material.dart';

class AlertDetail extends StatefulWidget {
  const AlertDetail({super.key});

  @override
  State<AlertDetail> createState() => _AlertDetailState();
}

class _AlertDetailState extends State<AlertDetail> {
  int _start = 10;
  Timer? _timer;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ALERT',
              style: context.theme.textTheme.headlineLarge
                  ?.copyWith(color: Colors.white),
            ),
            SizedBox(height: 15),
            Text('Call in ${_start}s',
                style: context.theme.textTheme.headlineMedium
                    ?.copyWith(color: Colors.white)),
            SizedBox(height: 20),
            Card(
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: VideoWidget(),
                )),
            SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Confirm',
                          style: context.theme.textTheme.labelLarge
                              ?.copyWith(color: Colors.white),
                        )),
                  ),
                ),
                SizedBox(width: 15),
                Flexible(
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade800),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: context.theme.textTheme.labelLarge
                              ?.copyWith(color: Colors.white),
                        )),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}

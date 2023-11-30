import 'dart:async';

import 'package:emer_app/app/services/firestore_ref.dart';
import 'package:emer_app/data/device_data.dart';
import 'package:emer_app/pages/device_form.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  StreamSubscription<dynamic>? unSub;
  List<DeviceData> devices = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      unSub = FsRef.device(context.authStore.profile!.id!)
          .snapshots()
          .map(
            (value) {
              return Stream.fromIterable(value.docs)
                  .map((e) => DeviceData.fromJson(
                      {'id': e.id, 'ref': e.reference, ...e.data()}))
                  .bufferCount(value.docs.length);
            },
          )
          .flatMap((v) => v)
          .listen((data) {
            setState(() {
              devices = data;
            });
          });
    });
  }

  @override
  void dispose() {
    unSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...devices
              .map((e) => Padding(
                    padding:
                        const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                    child: Card(
                      color: context.theme.primaryColor,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/images/image 30.png',
                                    fit: BoxFit.cover,
                                    width: double.maxFinite,
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Image.asset(
                                    'assets/images/Vector5.png',
                                    fit: BoxFit.cover,
                                    width: 50,
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                'Camera : ${e.name}',
                                style: context.theme.textTheme.titleMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                'Zone : ${e.zoneName}',
                                style: context.theme.textTheme.titleMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => DeviceForm(),
                  ));
            },
            child: Card(
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                width: double.maxFinite,
                height: 140,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

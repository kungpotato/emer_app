import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emer_app/data/profile_data.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:emer_app/shared/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrPage extends StatefulWidget {
  const MyQrPage({super.key});

  @override
  State<MyQrPage> createState() => _MyQrPageState();
}

class _MyQrPageState extends State<MyQrPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      appBar: AppBar(
        title: Text(
          'My QR Code',
          style: context.theme.appBarTheme.titleTextStyle
              ?.copyWith(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        backgroundColor: context.theme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 40, left: 40, top: 15),
        child: Observer(
          builder: (context) => Column(
            children: [
              if (context.authStore.profile != null)
                _cardItem(context.authStore.profile!),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: scanQR,
                child: Text(
                  'SCAN QR CODE',
                  style: context.theme.textTheme.labelLarge?.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardItem(ProfileData data) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: 40,
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(data.img ?? ''),
              radius: 60,
            ),
            Text(
              data.name,
              style: context.theme.textTheme.titleLarge
                  ?.copyWith(color: Colors.black),
            ),
            SizedBox(
              height: 15,
            ),
            QrImageView(
              padding: const EdgeInsets.all(12),
              data: data.id ?? '',
              backgroundColor: context.theme.colorScheme.background,
              errorStateBuilder: (context, error) {
                return Text(error.toString());
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get data';
    }

    if (!mounted) return;

    if (barcodeScanRes.contains('Failed') || barcodeScanRes.contains('-1')) {
      showSnack(context, text: 'Failed to get data', color: Colors.red);
    } else if (barcodeScanRes == context.authStore.profile?.id) {
      showSnack(context, text: 'Not allow own QR!!', color: Colors.red);
    } else {
      context.authStore.getProfileById(barcodeScanRes).listen((data) {
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
              content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(data?.img ?? ''),
                radius: 30,
              ),
              Text(
                data?.name ?? '',
                style: context.theme.textTheme.titleLarge
                    ?.copyWith(color: Colors.black),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await context.authStore.profile?.ref?.update({
                      'members': [
                        ...?context.authStore.profile?.members,
                        MemberData(
                                id: data?.id ?? '',
                                name: data?.name ?? '',
                                imgUrl: data?.img ?? '',
                                location: GeoPoint(
                                    data?.address?.location?.latitude ?? 0,
                                    data?.address?.location?.latitude ?? 0))
                            .toMap()
                      ]
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Add'))
            ],
          )),
        );
      });
    }
  }
}

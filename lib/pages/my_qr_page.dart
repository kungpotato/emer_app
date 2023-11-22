import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
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
              Card(
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
                        backgroundImage:
                            NetworkImage(context.authStore.profile?.img ?? ''),
                        radius: 60,
                      ),
                      Text(
                        context.authStore.profile?.name ?? '',
                        style: context.theme.textTheme.titleLarge
                            ?.copyWith(color: Colors.black),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      QrImageView(
                        padding: const EdgeInsets.all(12),
                        data: context.authStore.profile?.id ?? '',
                        backgroundColor: context.theme.colorScheme.background,
                        errorStateBuilder: (context, error) {
                          return Text(error.toString());
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {},
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
}

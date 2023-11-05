import 'package:emer_app/app/services/firestore_ref.dart';
import 'package:emer_app/data/health_info_data.dart';
import 'package:emer_app/data/profile_data.dart';
import 'package:emer_app/data/user_insurance_data.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class ConfirmPage extends StatefulWidget {
  const ConfirmPage({super.key, this.profile, this.health, this.insurance});

  final ProfileData? profile;
  final HealthInfoData? health;
  final UserInsuranceData? insurance;

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  bool isLoad = false;

  void _submit(bool fac) async {
    if (mounted) {
      setState(() {
        isLoad = true;
      });
      final res = await FsRef.profileRef
          .add({...widget.profile!.toMap(), 'assistant': fac});
      FsRef.insurance(res.id).add(widget.insurance!.toMap());
      FsRef.health(res.id).add(widget.health!.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: isLoad
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Emergency assistance entry\nin case of an emergency.',
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.titleLarge
                          ?.copyWith(color: context.theme.primaryColor)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                            onPressed: () {
                              _submit(true);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                'Yes',
                                style: context.theme.textTheme.headlineSmall
                                    ?.copyWith(color: Colors.white),
                              ),
                            )),
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                            onPressed: () {
                              _submit(false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                'No',
                                style: context.theme.textTheme.headlineSmall
                                    ?.copyWith(color: Colors.white),
                              ),
                            )),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}

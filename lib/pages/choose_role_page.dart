import 'package:emer_app/pages/doctor_profile_form_page.dart';
import 'package:emer_app/pages/user_profile_form_page.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class ChooseRolePage extends StatefulWidget {
  const ChooseRolePage({super.key});

  @override
  State<ChooseRolePage> createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends State<ChooseRolePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      bottomNavigationBar: SizedBox(
        height: 50,
        child: InkWell(
          onTap: () async {
            if (mounted) {
              if (index == 0) {
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const UserProfileFormPage(),
                  ),
                );
              } else {
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const DoctorProfileFormPage(),
                  ),
                );
              }
            }
          },
          child: ColoredBox(
            color: context.theme.primaryColor,
            child: Center(
              child: Text(
                'NEXT',
                style: context.theme.textTheme.headlineMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'What is your role?',
              style: context.theme.textTheme.headlineMedium
                  ?.copyWith(color: context.theme.primaryColor),
            ),
            const SizedBox(height: 60),
            SizedBox(
              height: 190,
              width: 300,
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        index = 0;
                      });
                    },
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: context.theme.colorScheme.background,
                      child: SizedBox(
                        width: 280,
                        height: 180,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Image.asset('assets/images/image 29.png'),
                        ),
                      ),
                    ),
                  ),
                  if (index == 0)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ClipOval(
                        child: ColoredBox(
                          color: context.theme.primaryColor,
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            SizedBox(
              height: 190,
              width: 300,
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: context.theme.colorScheme.background,
                      child: SizedBox(
                        width: 280,
                        height: 180,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Image.asset(
                            'assets/images/image-removebg-preview-7 1.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (index == 1)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ClipOval(
                        child: ColoredBox(
                          color: context.theme.primaryColor,
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

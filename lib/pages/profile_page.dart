import 'package:emer_app/pages/insuarance_page.dart';
import 'package:emer_app/pages/user_profile_form_page.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      border: Border.all(
                        color: context.theme.primaryColor,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: ((context.authStore.profile?.img?.isNotEmpty ??
                                false) ||
                            (context.authStore.user?.photoURL?.isNotEmpty ??
                                false))
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              context.authStore.profile?.img ??
                                  context.authStore.user?.photoURL ??
                                  '',
                            ),
                          )
                        : CircleAvatar(
                            radius: 50,
                            child: Text(
                              context.authStore.user!.email?[0] ?? '',
                              style: context.theme.textTheme.headlineMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      Text(
                        context.authStore.profile?.name ?? '',
                        style: context.theme.textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 20, bottom: 10),
              child: Text(
                'Profile',
                style: context.theme.textTheme.titleLarge,
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Information'),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) =>
                              const UserProfileFormPage(isEdit: true),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: ListTile(
                    leading: Image.asset('assets/images/Vector3.png'),
                    title: const Text('Medical history'),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {
                      //
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: ListTile(
                    leading: Image.asset('assets/images/Vector4.png'),
                    title: const Text('Insurance'),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const InsurancePage(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 40, bottom: 10),
                  child: Text(
                    'Help',
                    style: context.theme.textTheme.titleLarge,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: ListTile(
                    leading: Image.asset('assets/images/Vector3.png'),
                    title: const Text('Support'),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {
                      //
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

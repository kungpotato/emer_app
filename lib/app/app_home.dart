import 'package:emer_app/app/bottom_nav_custom.dart';
import 'package:emer_app/pages/device_page.dart';
import 'package:emer_app/pages/home_page.dart';
import 'package:emer_app/pages/member_page.dart';
import 'package:emer_app/pages/profile_page.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const MemberPage(),
    const DevicePage(),
    // Lottie.network(
    //   'https://assets3.lottiefiles.com/temp/lf20_LOzlt2.json',
    //   onLoaded: (p0) => const CircularProgressIndicator(),
    // ),
    const ProfilePage(),
  ];

  Future<void> _onItemTapped(int index) async {
    if (_selectedIndex == 1) {
      await Future<void>.delayed(Duration(seconds: 3));
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  AppBar? _getTitle() {
    switch (_selectedIndex) {
      case 1:
        return AppBar(
          title: const Text(''),
          elevation: 0,
          leading: Icon(
            Icons.arrow_back_ios,
            color: context.theme.primaryColor,
          ),
          actions: [
            TextButton.icon(
              onPressed: () {},
              label: Text(
                'ADD MEMBER',
                style: context.theme.textTheme.labelSmall?.copyWith(
                    color: context.theme.primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              icon: Icon(
                Icons.qr_code,
                color: context.theme.primaryColor,
              ),
            )
          ],
        );
      case 3:
        return AppBar(
          title: const Text(''),
          actions: [
            TextButton.icon(
              onPressed: () {
                context.authStore.signOut();
              },
              label: const Text('Sign out'),
              icon: const Icon(Icons.logout),
            ),
          ],
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getTitle(),
      body: _widgetOptions.elementAt(_selectedIndex),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavCustom(
        selectedIndex: _selectedIndex,
        onItemTap: _onItemTapped,
      ),
    );
  }
}

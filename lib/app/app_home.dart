import 'package:emer_app/app/bottom_nav_custom.dart';
import 'package:emer_app/app/services/firebase_messaging_service.dart';
import 'package:emer_app/pages/device_page.dart';
import 'package:emer_app/pages/home_page.dart';
import 'package:emer_app/pages/member_page.dart';
import 'package:emer_app/pages/my_qr_page.dart';
import 'package:emer_app/pages/profile_page.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key, this.isNoMsg});

  final bool? isNoMsg;

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
    // if (_selectedIndex == 1) {
    //   await Future<void>.delayed(Duration(seconds: 3));
    // }
    setState(() {
      _selectedIndex = index;
    });
  }

  AppBar? _getTitle() {
    switch (_selectedIndex) {
      case 1:
        return AppBar(
          title: Text(
            'Members',
            style: context.theme.textTheme.titleLarge
                ?.copyWith(color: context.theme.primaryColor),
          ),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => MyQrPage(),
                    ));
              },
              icon: Icon(
                Icons.qr_code,
                color: context.theme.primaryColor,
              ),
            )
          ],
        );
      case 2:
        return AppBar(
          title: Text(
            'Devices',
            style: context.theme.textTheme.titleLarge
                ?.copyWith(color: context.theme.primaryColor),
          ),
          elevation: 0,
          actions: [],
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.isNoMsg != true) {
        FirebaseMessagingService.instance.checkInitialMessage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getTitle(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavCustom(
        selectedIndex: _selectedIndex,
        onItemTap: _onItemTapped,
      ),
    );
  }
}

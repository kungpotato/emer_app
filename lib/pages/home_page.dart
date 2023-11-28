import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Observer(
            builder: (context) => Container(
              width: double.maxFinite,
              color: context.theme.primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 45),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            FeatherIcons.bell,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              context.authStore.profile?.img ?? ''),
                          radius: 60,
                        ),
                        Column(
                          children: [],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Image.asset(
            'assets/images/shape.png',
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

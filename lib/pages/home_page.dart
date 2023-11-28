import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:emer_app/shared/widget/card_member_item.dart';
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Observer(
                  builder: (context) => Container(
                    width: double.maxFinite,
                    color: context.theme.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 15, left: 15, bottom: 15),
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
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 50,
                            child: Image.asset(
                                'assets/images/weather-icon 1.png')),
                        Text(
                          '30ºC',
                          style: context.theme.textTheme.labelSmall,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 50,
                            child: Image.asset(
                                'assets/images/image-removebg-preview 1.png')),
                        Text(
                          'Good',
                          style: context.theme.textTheme.labelSmall,
                        ),
                        Text(
                          'PM 6.0',
                          style: context.theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 50,
                            child: Image.asset(
                                'assets/images/image-removebg-preview (2) 1.png')),
                        Text(
                          '70%',
                          style: context.theme.textTheme.labelSmall,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 50,
                            child: Image.asset(
                                'assets/images/ultraviolet-uv-icon 1.png')),
                        Text(
                          'VERY HIGH',
                          style: context.theme.textTheme.labelSmall,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.calendar_month),
                              label: Text(
                                'SCHEDULE',
                                style: context.theme.textTheme.labelMedium
                                    ?.copyWith(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                              ),
                              style: TextButton.styleFrom(
                                  iconColor: Colors.black87)),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MON 2',
                                    style: context.theme.textTheme.labelSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Doctor's appointment",
                                    style: context.theme.textTheme.labelSmall
                                        ?.copyWith(fontSize: 8),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MON 2',
                                    style: context.theme.textTheme.labelSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Doctor's appointment",
                                    style: context.theme.textTheme.labelSmall
                                        ?.copyWith(fontSize: 8),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                        flex: 3,
                        child: Image.asset(
                            'assets/images/image-removebg-preview (14) 2.png'))
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                            'assets/images/image-removebg-preview (9) 1.png'),
                        Text(
                          'MEDICATION SCHEDULE',
                          style: context.theme.textTheme.labelMedium?.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
            child: Observer(
              builder: (context) => Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MEMBER',
                            style: context.theme.textTheme.labelMedium
                                ?.copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                          ),
                          if (context.authStore.profile != null)
                            ...context.authStore.profile!.members
                                .map((e) => CardMember(data: e))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

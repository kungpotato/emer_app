import 'package:emer_app/data/profile_data.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CardMember extends StatelessWidget {
  const CardMember({super.key, required this.data});

  final MemberData data;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(data.imgUrl),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: context.theme.textTheme.titleLarge?.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          ClipOval(
                              child: Container(
                            color: Colors.green,
                            width: 8,
                            height: 8,
                          )),
                          SizedBox(width: 4),
                          Text('Online')
                        ],
                      )
                    ],
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: context.theme.primaryColor,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

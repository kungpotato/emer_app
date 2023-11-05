import 'dart:async';

import 'package:emer_app/app/services/firestore_ref.dart';
import 'package:emer_app/data/user_insurance_data.dart';
import 'package:emer_app/pages/insuarance_form_page.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class InsurancePage extends StatefulWidget {
  const InsurancePage({super.key});

  @override
  State<InsurancePage> createState() => _InsurancePageState();
}

class _InsurancePageState extends State<InsurancePage> {
  StreamSubscription<dynamic>? unSub;
  List<UserInsuranceData> list = [];
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      unSub = FsRef.insurance(context.authStore.profile!.id!)
          .snapshots()
          .map((event) {
        return event.docs
            .map((e) => UserInsuranceData.fromJson(
                  {'id': e.id, 'ref': e.reference, ...e.data()},
                ))
            .toList();
      }).listen((data) {
        setState(() {
          list = data;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    unSub?.cancel();
  }

  Widget _cardItem({required UserInsuranceData data}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => InsuranceFromPage(data: data),
            ));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/images/Ellipse 36.png',
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    data.company,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.theme.textTheme.titleMedium?.copyWith(),
                  ),
                  Text(
                    'W. ${data.name}',
                    style: context.theme.textTheme.bodySmall,
                  ),
                  Text(
                    'ID ${data.id}',
                    style: context.theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardAdd() {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const InsuranceFromPage(),
          ),
        );
        setState(() {
          isEdit = false;
        });
      },
      child: Card(
        color: Colors.grey.shade400,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: const SizedBox(
          width: double.maxFinite,
          height: 110,
          child: Icon(
            Icons.add,
            size: 70,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isEdit) {
          setState(() {
            isEdit = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Insurance'),
          actions: [
            if (!isEdit)
              IconButton(
                  onPressed: () {
                    setState(() {
                      isEdit = true;
                    });
                  },
                  icon: Icon(FeatherIcons.edit)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: list.map((e) => _cardItem(data: e)).toList(),
                  ),
                ),
              ),
              if (isEdit) _cardAdd(),
            ],
          ),
        ),
      ),
    );
  }
}

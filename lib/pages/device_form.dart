import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emer_app/app/services/firestore_ref.dart';
import 'package:emer_app/core/exceptions/app_error_hadler.dart';
import 'package:emer_app/data/device_data.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:emer_app/shared/helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DeviceForm extends StatefulWidget {
  const DeviceForm({super.key, this.data});

  final DeviceData? data;

  @override
  State<DeviceForm> createState() => _DeviceFormState();
}

class _DeviceFormState extends State<DeviceForm> {
  final _formKey = GlobalKey<FormState>();
  GeoPoint? position;
  bool isLoad = false;

  final _nameController = TextEditingController();
  final _zoneNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.data != null && mounted) {
      setState(() {
        _nameController.text = widget.data?.name ?? '';
        _zoneNameController.text = widget.data?.zoneName ?? '';
        position = widget.data?.location;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SET DEVICE'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  color: context.theme.primaryColor,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/image 30.png',
                          fit: BoxFit.cover,
                          width: double.maxFinite,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info,
                                color: Colors.white,
                                size: 25,
                              ),
                              Text(
                                'Information',
                                style: context.theme.textTheme.titleMedium
                                    ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                                hintText: 'Enter Camera name',
                                filled: true,
                                fillColor: context.theme.colorScheme.background,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                isDense: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _zoneNameController,
                            decoration: InputDecoration(
                                hintText: 'Enter your zone name',
                                filled: true,
                                fillColor: context.theme.colorScheme.background,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                isDense: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your zone name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                              onPressed: () {
                                if (isLoad) {
                                  return;
                                }
                                // if (position != null) {
                                //   _openMap(position!.latitude, position!.longitude);
                                // }
                                setState(() {
                                  isLoad = true;
                                });
                                _getCurrentLocation();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                context.theme.colorScheme.background,
                              ),
                              child: Padding(
                                padding:
                                const EdgeInsets.only(right: 10, left: 10),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (position != null)
                                      Icon(Icons.check_box,
                                          color: context.theme.primaryColor),
                                    if (position == null)
                                      Icon(Icons.close, color: Colors.red),
                                    Text(
                                      'Location',
                                      style: context.theme.textTheme.bodyMedium,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: isLoad
                                          ? CircularProgressIndicator()
                                          : Image.asset(
                                        'assets/images/logos_google-maps.png',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                            constraints: BoxConstraints(minWidth: 100),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    context.theme.colorScheme.background),
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  if (position == null) {
                                    showSnack(context,
                                        text: 'Location required!!!');
                                    return;
                                  }
                                  final data = DeviceData(
                                      name: _nameController.value.text,
                                      zoneName: _zoneNameController.value.text,
                                      location: position);
                                  if (widget.data != null) {
                                    await FsRef.device(
                                        context.authStore.profile!.id!)
                                        .doc(widget.data!.id!).update(
                                        data.toMap());
                                  } else {
                                    await FsRef.device(
                                        context.authStore.profile!.id!)
                                        .add(data.toMap());
                                  }
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Save',
                                  style: context.theme.textTheme.labelLarge
                                      ?.copyWith(color: Colors.black87),
                                )))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position pos = await determinePosition();
      if (mounted) {
        setState(() {
          position = GeoPoint(pos.latitude, pos.longitude);
        });
        showSnack(context, text: 'Get location success!!!');
      }
    } catch (e, st) {
      handleError(e, st);
    }
    setState(() {
      isLoad = false;
    });
  }
}

import 'dart:io';

import 'package:emer_app/app/services/firestore_ref.dart';
import 'package:emer_app/data/education_data.dart';
import 'package:emer_app/data/profile_data.dart';
import 'package:emer_app/data/work_adrress_data.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class DoctorProfileFormPage extends StatefulWidget {
  const DoctorProfileFormPage({super.key});

  @override
  State<DoctorProfileFormPage> createState() => _UserProfileFormPageState();
}

class _UserProfileFormPageState extends State<DoctorProfileFormPage> {
  // Future<void> _submit() async {
  //   await FbRef.profileRef.add({});
  // }
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'kung');
  final _surnameController = TextEditingController(text: 'potato');
  final _nicknameController = TextEditingController(text: 'somtouy');
  final _universityController = TextEditingController(text: 'test univer');
  final _educationLevelController = TextEditingController(text: 'graduation');
  final _spacialLevelController = TextEditingController(text: 'spacial');
  final _hospitalController = TextEditingController(text: 'hos');
  final _departureController = TextEditingController(text: 'depart');
  final _roleController = TextEditingController(text: 'test');

  String? photo;

  Future<String?> pickImage() async {
    final picker = ImagePicker();
    bool isUpload = false;
    return showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Choose an option'),
              content: isUpload
                  ? const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(child: CircularProgressIndicator()),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera),
                          title: const Text('Camera'),
                          onTap: () async {
                            final image = await picker.pickImage(
                              source: ImageSource.camera,
                            );
                            if (image != null) {
                              setState(() => isUpload = true);
                              final url = await uploadImage(File(image.path));
                              if (mounted) {
                                Navigator.pop(context, url);
                              }
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.image),
                          title: const Text('Gallery'),
                          onTap: () async {
                            final image = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              setState(() => isUpload = true);
                              final url = await uploadImage(File(image.path));
                              if (mounted) {
                                Navigator.pop(context, url);
                              }
                            }
                          },
                        ),
                      ],
                    ),
              actions: [
                if (!isUpload)
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<String?> uploadImage(File image) async {
    final fileExtension = p.extension(image.path);
    final ref = StRef.profileImgRef
        .child('/${DateTime.now().toIso8601String()}$fileExtension');
    final uploadTask = ref.putFile(image);

    final snapshot = await uploadTask.whenComplete(() {
      //
    });
    final downloadURL = await snapshot.ref.getDownloadURL();

    return downloadURL;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      photo =
          context.authStore.profile?.img ?? context.authStore.user?.photoURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.hideKeyBoard,
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        appBar: AppBar(
          title: const Text(''),
          elevation: 0,
          backgroundColor: context.theme.colorScheme.background,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        bottomNavigationBar: SizedBox(
          height: 50,
          child: InkWell(
            onTap: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              await FsRef.profileRef.add(
                ProfileData(
                  role: ProfileRole.user,
                  name: _nameController.value.text,
                  email: context.authStore.user?.email ?? '',
                  img: photo ?? context.authStore.user?.photoURL,
                  education: EducationData(
                    hospital: _hospitalController.value.text,
                    departure: _departureController.value.text,
                    role: _roleController.value.text,
                  ),
                  workAddress: WorkAddressData(
                    hospital: _hospitalController.value.text,
                    departure: _departureController.value.text,
                    role: _roleController.value.text,
                  ),
                ).toMap(),
              );
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'MY PROFILE',
                    style: context.theme.textTheme.headlineMedium
                        ?.copyWith(color: context.theme.primaryColor),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      final img = await pickImage();
                      setState(() {
                        photo = img;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        border: Border.all(
                          color: context.theme.primaryColor,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: (photo?.isNotEmpty ?? false)
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                photo!,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(15),
                              child: Icon(
                                Icons.add,
                                size: 80,
                                color: context.theme.primaryColor,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Information',
                      style: context.theme.textTheme.titleLarge,
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            focusedBorder: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: TextFormField(
                          controller: _surnameController,
                          decoration: const InputDecoration(
                            labelText: 'Surname',
                            focusedBorder: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(),
                            errorBorder: UnderlineInputBorder(),
                            border: UnderlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter surname';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _nicknameController,
                          decoration: const InputDecoration(
                            labelText: 'Nickname',
                            focusedBorder: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(),
                            errorBorder: UnderlineInputBorder(),
                            border: UnderlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter nickname';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Flexible(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Education',
                      style: context.theme.textTheme.titleLarge,
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _universityController,
                          decoration: const InputDecoration(
                            labelText: 'University',
                            focusedBorder: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter University';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: TextFormField(
                          controller: _educationLevelController,
                          decoration: const InputDecoration(
                            labelText: 'Education level',
                            focusedBorder: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(),
                            errorBorder: UnderlineInputBorder(),
                            border: UnderlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Education level';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _spacialLevelController,
                          decoration: const InputDecoration(
                            labelText: 'Specialist',
                            focusedBorder: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(),
                            errorBorder: UnderlineInputBorder(),
                            border: UnderlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Specialist';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Flexible(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Working Address',
                      style: context.theme.textTheme.titleLarge,
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _hospitalController,
                          decoration: const InputDecoration(
                            labelText: 'Hospital',
                            focusedBorder: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Hospital';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: TextFormField(
                          controller: _departureController,
                          decoration: const InputDecoration(
                            labelText: 'Departure',
                            focusedBorder: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(),
                            errorBorder: UnderlineInputBorder(),
                            border: UnderlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Departure';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _roleController,
                          decoration: const InputDecoration(
                            labelText: 'Role',
                            focusedBorder: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(),
                            errorBorder: UnderlineInputBorder(),
                            border: UnderlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Role';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Flexible(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

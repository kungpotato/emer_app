import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emer_app/app/services/firestore_ref.dart';
import 'package:emer_app/core/exceptions/app_error_hadler.dart';
import 'package:emer_app/data/profile_data.dart';
import 'package:emer_app/pages/health_info_form_page.dart';
import 'package:emer_app/shared/constants/constant.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:emer_app/shared/extensions/date_extension.dart';
import 'package:emer_app/shared/helper.dart';
import 'package:emer_app/shared/utils/picker_utils.dart';
import 'package:emer_app/shared/widget/input_widget.dart';
import 'package:emer_app/shared/widget/select_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:url_launcher/url_launcher.dart';

const List<String> prefixNameList = <String>[
  "Mr.",
  "Mrs.",
  "Miss",
  "Ms.",
  "Dr.",
  "Prof.",
  "Rev.",
  "Hon."
];
const List<String> bloodList = <String>[
  "A",
  "A+",
  "A-",
  "B",
  "B+",
  "B-",
  "O",
  "O+",
  "O-"
];

class UserProfileFormPage extends StatefulWidget {
  const UserProfileFormPage({super.key, this.isEdit = false});

  final bool isEdit;

  @override
  State<UserProfileFormPage> createState() => _UserProfileFormPageState();
}

class _UserProfileFormPageState extends State<UserProfileFormPage> {
  late FormGroup form;

  String? photo;
  GeoPoint? position;

  @override
  void initState() {
    super.initState();
    _initFormGroups();
    _getCurrentLocation();
    setState(() {
      photo =
          context.authStore.profile?.img ?? context.authStore.user?.photoURL;
    });
  }

  void _initFormGroups() {
    final profile = context.authStore.profile;
    form = FormGroup({
      'idCard': FormControl<String>(value: profile?.idCard, validators: [
        Validators.required,
      ]),
      'namePrefix':
          FormControl<String>(value: profile?.namePrefix, validators: [
        Validators.required,
      ]),
      'name': FormControl<String>(value: profile?.name, validators: [
        Validators.required,
      ]),
      'birthday': FormControl<String>(
          value: profile?.birthday?.toDate().isoDate,
          validators: [
            Validators.required,
          ]),
      'height': FormControl<String>(value: profile?.height),
      'weight': FormControl<String>(value: profile?.weight),
      'blood': FormControl<String>(value: profile?.blood, validators: [
        Validators.required,
      ]),
      'address': FormGroup({
        'address':
            FormControl<String>(value: profile?.address?.address, validators: [
          Validators.required,
        ]),
        'district':
            FormControl<String>(value: profile?.address?.district, validators: [
          Validators.required,
        ]),
        'province':
            FormControl<String>(value: profile?.address?.province, validators: [
          Validators.required,
        ]),
        'postcode':
            FormControl<String>(value: profile?.address?.postcode, validators: [
          Validators.required,
        ]),
        'country': FormControl<String>(
            value: profile?.address?.country ?? 'Thailand',
            validators: [
              Validators.required,
            ]),
      }),
      'contact': FormGroup({
        'phone':
            FormControl<String>(value: profile?.contact?.phone, validators: [
          Validators.required,
        ]),
        'email':
            FormControl<String>(value: profile?.contact?.email, validators: [
          Validators.email,
          Validators.required,
        ]),
      }),
    });
  }

  void _getCurrentLocation() async {
    try {
      Position pos = await determinePosition();
      setState(() {
        position = GeoPoint(pos.latitude, pos.longitude);
      });
    } catch (e, st) {
      handleError(e, st);
    }
  }

  Future<void> _onSubmit(Map<String, dynamic> formData) async {
    final data = ProfileData.fromJson({
      ...formData,
      'birthday': parseDate(formData['birthday'] as String).toTimestamp(),
      'email': context.authStore.user?.email ?? "",
      'img': photo,
    });

    if (widget.isEdit) {
      await FsRef.profileRef
          .doc(context.authStore.profile!.id)
          .update(data.toMap());
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute<bool?>(
          builder: (context) => HealthInfoFormPage(profile: data),
        ),
      );
    }
  }

  void printInvalidFields(Map<String, AbstractControl<Object?>> controls) {
    controls.forEach((name, control) {
      if (control.invalid) {
        print('Field $name is invalid: ${control.errors}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.hideKeyBoard,
      child: ReactiveForm(
        formGroup: form,
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
            child: ReactiveFormConsumer(builder: (context, formGroup, child) {
              return InkWell(
                onTap: () async {
                  if (formGroup.valid) {
                    _onSubmit(formGroup.value);
                  } else {
                    printInvalidFields(formGroup.controls);
                    formGroup.markAllAsTouched();
                  }
                },
                child: ColoredBox(
                  color: context.theme.primaryColor,
                  child: Center(
                    child: Text(
                      widget.isEdit ? 'SUBMIT' : 'NEXT',
                      style: context.theme.textTheme.headlineMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              );
            }),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
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
                      var imagePickerService = ImagePickerService(
                          context: context, fbRef: StRef.profileImgRef);
                      final img = await imagePickerService.pickImage();
                      if (img != null) {
                        setState(() {
                          photo = img;
                        });
                      }
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
                  _buildInfo(),
                  const SizedBox(height: 20),
                  _buildAddress(),
                  const SizedBox(height: 20),
                  _buildContact(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required String name,
  }) {
    return InputWidget<String>(
      label: label,
      name: name,
      onTap: (control) async {
        final selectedDate = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null) {
          control.value = picked.isoDate;
        }
      },
    );
  }

  Widget _buildInfo() {
    return Card(
      color: context.theme.colorScheme.background,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Information',
                style: context.theme.textTheme.titleLarge,
              ),
            ),
            InputWidget<String>(
              label: 'Citizen Id',
              name: 'idCard',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Flexible(
                    flex: 2,
                    child: SelectWidget(
                        name: 'namePrefix',
                        items: prefixNameList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        label: 'Prefix')),
                const SizedBox(width: 8),
                Flexible(
                  flex: 4,
                  child: InputWidget<String>(label: 'Full Name', name: 'name'),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Flexible(
                  child: _buildDatePicker(
                    label: 'Birthday',
                    name: 'birthday',
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: SelectWidget(
                      label: 'Blood',
                      name: 'blood',
                      items: bloodList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Flexible(
                  child: InputWidget<String>(
                    label: 'Height',
                    name: 'height',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: InputWidget<String>(
                    label: 'Weight',
                    name: 'weight',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                const SizedBox(width: 8),
                const Flexible(
                  child: SizedBox(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddress() {
    return Card(
      color: context.theme.colorScheme.background,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Address',
                style: context.theme.textTheme.titleLarge,
              ),
            ),
            InputWidget<String>(label: 'Address', name: 'address.address'),
            SizedBox(height: 15),
            Row(
              children: [
                Flexible(
                  child: InputWidget<String>(
                      label: 'City/District', name: 'address.district'),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: SelectWidget(
                      label: 'Province',
                      name: 'address.province',
                      items: thaiProvinces
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  child: InputWidget<String>(
                    label: 'Postcode',
                    name: 'address.postcode',
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: SelectWidget(
                      label: 'County',
                      name: 'address.country',
                      items: ['Thailand']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  if (position != null) {
                    _openMap(position!.latitude, position!.longitude);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.theme.colorScheme.background,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Location',
                        style: context.theme.textTheme.bodyMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/images/logos_google-maps.png',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMap(double latitude, double longitude) async {
    final googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    final uri = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }

  Widget _buildContact() {
    return Card(
      color: context.theme.colorScheme.background,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Contact',
                style: context.theme.textTheme.titleLarge,
              ),
            ),
            InputWidget<String>(
              label: 'Phone Number',
              name: 'contact.phone',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15),
            InputWidget<String>(label: 'Email', name: 'contact.email'),
          ],
        ),
      ),
    );
  }
}

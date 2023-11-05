import 'package:emer_app/app/services/firestore_ref.dart';
import 'package:emer_app/data/health_info_data.dart';
import 'package:emer_app/data/profile_data.dart';
import 'package:emer_app/pages/insuarance_form_page.dart';
import 'package:emer_app/pages/user_profile_form_page.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:emer_app/shared/widget/input_widget.dart';
import 'package:emer_app/shared/widget/select_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class HealthInfoFormPage extends StatefulWidget {
  const HealthInfoFormPage({super.key, this.data, this.profile});

  final HealthInfoData? data;
  final ProfileData? profile;

  @override
  State<HealthInfoFormPage> createState() => _UserProfileFormPageState();
}

class _UserProfileFormPageState extends State<HealthInfoFormPage> {
  Future<void> _onSubmit(Map<String, dynamic> formData) async {
    final data = HealthInfoData.fromJson(formData);

    if (widget.data != null) {
      await FsRef.health(context.authStore.profile!.id!)
          .doc(data.id)
          .update(data.toMap());
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute<bool?>(
          builder: (context) =>
              InsuranceFromPage(health: data, profile: widget.profile),
        ),
      );
    }
  }

  late FormGroup formGroup1;
  late FormGroup form;

  @override
  void initState() {
    super.initState();
    _initFormGroups();
  }

  void _initFormGroups() {
    form = FormGroup({
      'hospital1':
          FormControl<String>(value: widget.data?.hospital1, validators: [
        Validators.required,
      ]),
      'hospital2': FormControl<String>(value: widget.data?.hospital2),
      'phone1': FormControl<String>(value: widget.data?.phone1, validators: [
        Validators.required,
      ]),
      'phone2': FormControl<String>(value: widget.data?.phone2),
      'medicalHistory': FormGroup({
        'chronic':
            FormControl<String>(value: widget.data?.medicalHistory.chronic),
        'current':
            FormControl<String>(value: widget.data?.medicalHistory.current),
        'allergic':
            FormControl<String>(value: widget.data?.medicalHistory.allergic),
      }),
      'physicians': widget.data != null
          ? FormArray(widget.data!.physicians
              .map((e) => FormGroup({
                    'prefix': FormControl<String>(value: e.prefix),
                    'name': FormControl<String>(value: e.name),
                    'department': FormControl<String>(value: e.department),
                    'disease': FormControl<String>(value: e.disease),
                    'medication': FormControl<String>(value: e.medication),
                    'hospital': FormControl<String>(value: e.hospital),
                  }))
              .toList())
          : FormArray([
              FormGroup({
                'prefix': FormControl<String>(value: 'Mr.'),
                'name': FormControl<String>(value: ''),
                'department': FormControl<String>(value: ''),
                'disease': FormControl<String>(value: ''),
                'medication': FormControl<String>(value: ''),
                'hospital': FormControl<String>(value: ''),
              })
            ]),
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
            child: ReactiveFormConsumer(
              builder: (context, formGroup, child) {
                return InkWell(
                  onTap: () async {
                    // _onSubmit(formGroup.value);
                    if (formGroup.valid) {
                      _onSubmit(formGroup.value);
                    } else {
                      formGroup.markAllAsTouched();
                    }
                  },
                  child: ColoredBox(
                    color: context.theme.primaryColor,
                    child: Center(
                      child: Text(
                        widget.data != null ? 'SUBMIT' : 'NEXT',
                        style: context.theme.textTheme.headlineMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  Text(
                    'HEALTH INFOMATION',
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.headlineSmall
                        ?.copyWith(color: context.theme.primaryColor),
                  ),
                  const SizedBox(height: 20),
                  _buildMedical(),
                  const SizedBox(height: 20),
                  _buildPersonalPhy(),
                  const SizedBox(height: 20),
                  _buildHospital(),
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

  Widget _buildMedical() {
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
                'Medical History',
                style: context.theme.textTheme.titleLarge,
              ),
            ),
            InputWidget<String>(
                label: 'Chronic Disease', name: 'medicalHistory.chronic'),
            InputWidget<String>(
                label: 'Current Medication', name: 'medicalHistory.current'),
            InputWidget<String>(
                label: 'Allergic Medication', name: 'medicalHistory.allergic'),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalPhy() {
    final formList =
        form.control('physicians') as FormArray<Map<String, Object?>>;
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Personal Physician History',
                    style: context.theme.textTheme.titleLarge,
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          var newFormGroup = FormGroup({
                            'prefix': FormControl<String>(value: ''),
                            'name': FormControl<String>(value: ''),
                            'department': FormControl<String>(value: ''),
                            'disease': FormControl<String>(value: ''),
                            'medication': FormControl<String>(value: ''),
                            'hospital': FormControl<String>(value: ''),
                          });
                          formList.add(newFormGroup);
                        });
                      },
                      icon: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.theme.primaryColor,
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          color: context.theme.primaryColor,
                        ),
                      ))
                ],
              ),
            ),
            ...formList.controls
                .asMap()
                .entries
                .map((e) => ReactiveForm(
                      key: UniqueKey(),
                      formGroup: e.value as FormGroup,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (e.key != 0)
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    formList.removeAt(e.key);
                                  });
                                },
                                icon: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: context.theme.primaryColor,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: context.theme.primaryColor,
                                  ),
                                )),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                  flex: 2,
                                  child: SelectWidget<String>(
                                      name: 'prefix',
                                      items: prefixNameList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      label: 'Prefix')),
                              const SizedBox(width: 8),
                              Flexible(
                                flex: 4,
                                child: InputWidget<String>(
                                  label: 'Full Name',
                                  name: 'name',
                                ),
                              ),
                            ],
                          ),
                          InputWidget<String>(
                              label: 'Medical Department', name: 'department'),
                          InputWidget<String>(
                              label: 'Disease', name: 'disease'),
                          InputWidget<String>(
                              label: 'Treatment medication',
                              name: 'medication'),
                          InputWidget<String>(
                              label: 'Hospital Name', name: 'hospital'),
                          if (formList.controls.length > 1)
                            Divider(
                              thickness: 2,
                            )
                        ],
                      ),
                    ))
                .toList()
          ],
        ),
      ),
    );
  }

  Widget _buildHospital() {
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
                'Emergency Hospital',
                style: context.theme.textTheme.titleLarge,
              ),
            ),
            InputWidget<String>(
              label: 'Hospital Name 1',
              name: 'hospital1',
            ),
            InputWidget<String>(label: 'Hospital Name 2', name: 'hospital2')
          ],
        ),
      ),
    );
  }

  Widget _buildContact() {
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
                'Emergency Contact',
                style: context.theme.textTheme.titleLarge,
              ),
            ),
            InputWidget<String>(
              label: 'Emergency Number 1',
              name: 'phone1',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
            InputWidget<String>(
              label: 'Emergency Number 2',
              name: 'phone2',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            )
          ],
        ),
      ),
    );
  }
}

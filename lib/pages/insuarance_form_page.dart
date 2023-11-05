import 'dart:convert';

import 'package:emer_app/app/services/firestore_ref.dart';
import 'package:emer_app/data/health_info_data.dart';
import 'package:emer_app/data/insuarance_data.dart';
import 'package:emer_app/data/profile_data.dart';
import 'package:emer_app/data/user_insurance_data.dart';
import 'package:emer_app/pages/confirm_page.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:emer_app/shared/extensions/date_extension.dart';
import 'package:emer_app/shared/helper.dart';
import 'package:emer_app/shared/utils/picker_utils.dart';
import 'package:emer_app/shared/widget/input_widget.dart';
import 'package:emer_app/shared/widget/select_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

final coverageList = [
  'Life Insurance',
  'Health Insurance',
  'Accident Insurance'
];

class InsuranceFromPage extends StatefulWidget {
  const InsuranceFromPage({super.key, this.data, this.profile, this.health});

  final UserInsuranceData? data;
  final ProfileData? profile;
  final HealthInfoData? health;

  @override
  State<InsuranceFromPage> createState() => _InsuranceFromPageState();
}

class _InsuranceFromPageState extends State<InsuranceFromPage> {
  late FormGroup form;
  List<InsuranceData> _kOptions = [];
  InsuranceData? current;
  String? photo;

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      'company': FormControl<String>(value: widget.data?.company, validators: [
        Validators.required,
      ]),
      'policyNumber':
          FormControl<String>(value: widget.data?.policyNumber, validators: [
        Validators.required,
      ]),
      'name': FormControl<String>(value: widget.data?.name, validators: [
        Validators.required,
      ]),
      'surname': FormControl<String>(value: widget.data?.surname, validators: [
        Validators.required,
      ]),
      'coverageType':
          FormControl<String>(value: widget.data?.coverageType, validators: [
        Validators.required,
      ]),
      'start': FormControl<String>(
          value: widget.data?.start.toDate().isoDate,
          validators: [
            Validators.required,
          ]),
      'end': FormControl<String>(
          value: widget.data?.end.toDate().isoDate,
          validators: [
            Validators.required,
          ]),
      'agentName': FormControl<String>(
        value: widget.data?.agentName,
      ),
      'agentNumber': FormControl<String>(
        value: widget.data?.agentNumber,
      ),
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final res = await loadJson();
      setState(() {
        _kOptions = res;
        photo = widget.data?.cardUrl ?? widget.data?.img;
      });
    });
  }

  Future<List<InsuranceData>> loadJson() async {
    String jsonString =
        await rootBundle.loadString('assets/json/insuarance.json');
    final list = jsonDecode(jsonString) as List;
    return list
        .map((e) => InsuranceData.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _onSubmit(Map<String, dynamic> formData) async {
    final data = UserInsuranceData.fromJson({
      ...formData,
      'start': parseDate(formData['start'] as String).toTimestamp(),
      'end': parseDate(formData['end'] as String).toTimestamp(),
      'img': photo,
      'cardUrl': photo,
    });

    if (widget.data == null) {
      await Navigator.push(
        context,
        MaterialPageRoute<bool?>(
          builder: (context) => ConfirmPage(
              profile: widget.profile, health: widget.health, insurance: data),
        ),
      );
    } else {
      FsRef.insurance(context.authStore.profile!.id!)
          .doc(widget.data!.id)
          .update(data.toMap());
    }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.hideKeyBoard,
      child: ReactiveForm(
        formGroup: form,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Insurance'),
            actions: [
              if (widget.data == null)
                TextButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<bool?>(
                          builder: (context) => ConfirmPage(
                            profile: widget.profile,
                            health: widget.health,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Skip',
                      style: context.theme.textTheme.labelMedium
                          ?.copyWith(color: context.theme.primaryColor),
                    ))
            ],
          ),
          bottomNavigationBar: SizedBox(
            height: 50,
            child: ReactiveFormConsumer(builder: (context, formGroup, child) {
              return InkWell(
                onTap: () {
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
            }),
          ),
          body: Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildMedical(),
                  _buildAgent(),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () async {
                      var imagePickerService = ImagePickerService(
                          context: context, fbRef: StRef.insuranceImgRef);
                      final img = await imagePickerService.pickImage();
                      if (img != null) {
                        setState(() {
                          photo = img;
                        });
                      }
                    },
                    child: Container(
                      width: double.maxFinite,
                      child: Card(
                        color: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 8,
                        clipBehavior: Clip.hardEdge,
                        child: photo != null
                            ? Image.network(
                                photo!,
                                fit: BoxFit.fill,
                                width: double.maxFinite,
                                height: 200,
                              )
                            : Padding(
                                padding: EdgeInsets.only(top: 40, bottom: 40),
                                child: Text(
                                  'Upload Your\n Insurance Card',
                                  textAlign: TextAlign.center,
                                  style: context.theme.textTheme.headlineSmall
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAutoComplete() {
    return Autocomplete<InsuranceData>(
      initialValue: TextEditingValue(text: widget.data?.company ?? ''),
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<InsuranceData>.empty();
        }
        return _kOptions.where((option) {
          return option.name.contains(textEditingValue.text.toLowerCase());
        });
      },
      displayStringForOption: (option) => option.name,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) =>
              InputWidget<String>(
        label: 'Insurance Company',
        name: 'company',
        controller: textEditingController,
        focusNode: focusNode,
      ),
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          elevation: 4,
          child: ListView(
            children: options
                .map((e) => ListTile(
                      dense: true,
                      title: Text(e.name),
                      onTap: () {
                        onSelected(e);
                        setState(() {
                          current = e;
                          form.control('company').value = e.name;
                        });
                      },
                    ))
                .toList(),
          ),
        ),
      ),
      onSelected: (selection) {
        setState(() {
          current = selection;
        });
      },
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
                'Infomation',
                style: context.theme.textTheme.titleLarge,
              ),
            ),
            _buildAutoComplete(),
            InputWidget<String>(
              label: 'Policy number',
              name: 'policyNumber',
            ),
            Row(
              children: [
                Flexible(
                  child: InputWidget<String>(label: 'Name', name: 'name'),
                ),
                Flexible(
                  child: InputWidget<String>(label: 'Surname', name: 'surname'),
                ),
              ],
            ),
            SelectWidget<String>(
                name: 'coverageType',
                items:
                    coverageList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                label: 'Coverage Type'),
            Row(
              children: [
                Flexible(
                    child: _buildDatePicker(label: 'Start', name: 'start')),
                Flexible(child: _buildDatePicker(label: 'End', name: 'end'))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAgent() {
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
                'Insurance Agent',
                style: context.theme.textTheme.titleLarge,
              ),
            ),
            InputWidget<String>(
              label: 'Full Name',
              name: 'agentName',
            ),
            InputWidget<String>(
              label: 'Phone Number',
              name: 'agentNumber',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}

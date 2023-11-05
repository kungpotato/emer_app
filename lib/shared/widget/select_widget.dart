import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SelectWidget<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final String label;
  final String? name;
  final FormControl<T>? formControl;

  const SelectWidget({
    Key? key,
    required this.items,
    required this.label,
    this.name,
    this.formControl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 3,
              spreadRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(40),
        ),
        child: ReactiveDropdownField<T>(
          formControlName: name,
          formControl: formControl,
          icon: const Icon(Icons.arrow_drop_down),
          isExpanded: true,
          isDense: true,
          decoration: InputDecoration(
              labelText: label, contentPadding: const EdgeInsets.all(15)),
          items: items,
        ),
      ),
    );
  }
}

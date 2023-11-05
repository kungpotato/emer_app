import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class InputWidget<T> extends StatelessWidget {
  final String label;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? name;
  final FormControl<T>? formControl;
  final void Function(FormControl<T>)? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const InputWidget({
    Key? key,
    required this.label,
    this.inputFormatters,
    this.keyboardType,
    this.name,
    this.formControl,
    this.onTap,
    this.controller,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
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
        child: ReactiveTextField<T>(
          formControlName: name,
          formControl: formControl,
          controller: controller,
          focusNode: focusNode,
          onTap: onTap,
          decoration: InputDecoration(labelText: label, isDense: true),
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}

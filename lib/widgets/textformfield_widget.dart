import 'package:flutter/material.dart';

class TextformWidget extends StatelessWidget {
  const TextformWidget({
    super.key,
    required this.hintText,
    required this.controller,
    required this.textInputType,
    required this.validator,
    required InputDecoration decoration,
  });

  final String hintText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      validator: validator,
      decoration: InputDecoration(
          border: const OutlineInputBorder(), hintText: hintText),
    );
  }
}

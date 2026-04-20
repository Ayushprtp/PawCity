import 'package:flutter/material.dart';
import 'package:pawcity/shared/widgets/paw_text_field.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.label,
    required this.controller,
    super.key,
    this.obscureText = false,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return PawTextField(
      label: label,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}
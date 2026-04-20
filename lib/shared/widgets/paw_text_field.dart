import 'package:flutter/material.dart';

class PawTextField extends StatelessWidget {
  const PawTextField({
    required this.label,
    required this.controller,
    super.key,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: obscureText ? 1 : maxLines,
      decoration: InputDecoration(labelText: label),
    );
  }
}
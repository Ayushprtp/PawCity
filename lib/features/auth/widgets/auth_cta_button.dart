import 'package:flutter/material.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';

class AuthCtaButton extends StatelessWidget {
  const AuthCtaButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return PawGradientButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }
}
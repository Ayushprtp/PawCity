import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';

/// An enhanced text field for auth screens with prefix icons,
/// password visibility toggle, and polished input decoration.
class AuthTextField extends StatefulWidget {
  const AuthTextField({
    required this.label,
    required this.controller,
    super.key,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.textInputAction,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  IconData _inferPrefixIcon() {
    if (widget.prefixIcon != null) return widget.prefixIcon!;
    final lower = widget.label.toLowerCase();
    if (lower.contains('email')) return Icons.email_outlined;
    if (lower.contains('password')) return Icons.lock_outline_rounded;
    if (lower.contains('name')) return Icons.person_outline_rounded;
    if (lower.contains('phone')) return Icons.phone_outlined;
    return Icons.text_fields_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: widget.controller,
      obscureText: _obscured,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(_inferPrefixIcon()),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _obscured
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    key: ValueKey(_obscured),
                    color: colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
                ),
                onPressed: () => setState(() => _obscured = !_obscured),
                splashRadius: 20,
                tooltip: _obscured ? 'Show password' : 'Hide password',
              )
            : null,
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md + 2,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
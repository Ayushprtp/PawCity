import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';

class PawFilterChipGroup extends StatelessWidget {
  const PawFilterChipGroup({
    required this.options,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.sm,
      runSpacing: AppSizes.sm,
      children: options
          .map(
            (item) => ChoiceChip(
              label: Text(item),
              selected: item == selected,
              onSelected: (_) => onSelected(item),
            ),
          )
          .toList(),
    );
  }
}
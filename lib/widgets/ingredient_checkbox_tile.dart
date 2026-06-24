import 'package:flutter/material.dart';
import '../models/ingredient.dart';

class IngredientCheckboxTile extends StatelessWidget {
  final Ingredient ingredient;
  final VoidCallback onTap;

  const IngredientCheckboxTile({
    super.key,
    required this.ingredient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(ingredient.name),
      value: ingredient.isSelected,
      onChanged: (_) => onTap(),
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }
}

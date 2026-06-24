import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final RecipeMatchResult result;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.result,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (result.matchRate * 100).toStringAsFixed(0);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(
          result.recipe.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          result.missingIngredients.isEmpty
              ? '보유 재료로 모두 만들 수 있어요'
              : '부족한 재료: ${result.missingIngredients.join(', ')}',
        ),
        trailing: Text(
          '$percent%',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onTap: onTap,
      ),
    );
  }
}

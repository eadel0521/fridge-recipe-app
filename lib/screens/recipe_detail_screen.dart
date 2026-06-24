import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final RecipeMatchResult result;

  const RecipeDetailScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final recipe = result.recipe;

    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (recipe.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                recipe.imageUrl,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          const SizedBox(height: 16),
          Text('필요한 재료', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: recipe.ingredientNames.map((name) {
              final isOwned = result.matchedIngredients.contains(name);
              return Chip(
                label: Text(name),
                backgroundColor:
                    isOwned ? Colors.green.shade100 : Colors.grey.shade200,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text('조리 방법', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(recipe.cookingSteps),
        ],
      ),
    );
  }
}

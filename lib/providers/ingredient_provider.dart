import 'package:flutter/material.dart';
import '../models/ingredient.dart';
import '../data/default_ingredients.dart';

class IngredientProvider extends ChangeNotifier {
  final List<Ingredient> _ingredients = getDefaultIngredients();

  List<Ingredient> get ingredients => _ingredients;

  // 카테고리별로 묶어서 반환 (화면에서 섹션별로 보여줄 때 사용)
  Map<IngredientCategory, List<Ingredient>> get groupedByCategory {
    final Map<IngredientCategory, List<Ingredient>> result = {};
    for (final ing in _ingredients) {
      result.putIfAbsent(ing.category, () => []).add(ing);
    }
    return result;
  }

  List<Ingredient> get selectedIngredients =>
      _ingredients.where((e) => e.isSelected).toList();

  // 검색어로 필터링된 재료 리스트
  List<Ingredient> search(String keyword) {
    if (keyword.trim().isEmpty) return [];
    return _ingredients
        .where((e) => e.name.contains(keyword.trim()))
        .toList();
  }

  void toggleSelection(String ingredientId) {
    final ing = _ingredients.firstWhere((e) => e.id == ingredientId);
    ing.isSelected = !ing.isSelected;
    notifyListeners();
  }

  void clearSelection() {
    for (final ing in _ingredients) {
      ing.isSelected = false;
    }
    notifyListeners();
  }
}

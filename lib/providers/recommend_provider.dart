import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../data/recipe_api.dart';
import '../models/recipe.dart';

class RecommendProvider extends ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();
  final RecipeApi _api = RecipeApi();

  List<Recipe> _allRecipes = [];
  List<RecipeMatchResult> _matchResults = [];
  bool isLoading = false;
  String? errorMessage;

  List<RecipeMatchResult> get matchResults => _matchResults;

  Future<void> initRecipes() async {
    // ignore: avoid_print
    print('initRecipes 시작');
    isLoading = true;
    notifyListeners();

    try {
      final count = await _dbHelper.getRecipeCount();
      // ignore: avoid_print
      print('DB 레시피 수: $count');

      if (count == 0) {
        // ignore: avoid_print
        print('API 호출 시작');
        final fetched = await _api.fetchRecipes(startIdx: 1, endIdx: 1000);
        // ignore: avoid_print
        print('API에서 받은 레시피 수: ${fetched.length}');
        await _dbHelper.insertRecipes(fetched);
      }

      _allRecipes = await _dbHelper.getAllRecipes();
      // ignore: avoid_print
      print('최종 로드된 레시피 수: ${_allRecipes.length}');
      errorMessage = null;
    } catch (e) {
      // ignore: avoid_print
      print('initRecipes 오류: $e');
      errorMessage = '레시피 데이터를 불러오지 못했습니다: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  void recommend(List<String> selectedIngredientNames) {
    // ignore: avoid_print
    print('=== 디버그 ===');
    // ignore: avoid_print
    print('전체 레시피 수: ${_allRecipes.length}');
    // ignore: avoid_print
    print('선택한 재료: $selectedIngredientNames');

    if (_allRecipes.isNotEmpty) {
      // ignore: avoid_print
      print('첫 번째 레시피: ${_allRecipes[0].name}');
      // ignore: avoid_print
      print('첫 번째 레시피 재료: ${_allRecipes[0].ingredientNames}');
    }

    if (selectedIngredientNames.isEmpty) {
      _matchResults = [];
      notifyListeners();
      return;
    }

    final selectedSet = selectedIngredientNames.toSet();
    final results = <RecipeMatchResult>[];

    for (final recipe in _allRecipes) {
      final matched = recipe.ingredientNames
          .where((name) => selectedSet.contains(name))
          .toList();

      if (matched.isEmpty) continue;

      final missing = recipe.ingredientNames
          .where((name) => !selectedSet.contains(name))
          .toList();

      results.add(
        RecipeMatchResult(
          recipe: recipe,
          matchedIngredients: matched,
          missingIngredients: missing,
        ),
      );
    }

    results.sort((a, b) => b.matchRate.compareTo(a.matchRate));
    _matchResults = results;
    notifyListeners();
  }
}

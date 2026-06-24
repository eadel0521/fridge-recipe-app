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

  // 앱 시작 시 호출: 로컬 DB에 레시피 없으면 API에서 받아와 캐싱
  Future<void> initRecipes() async {
    isLoading = true;
    notifyListeners();

    try {
      final count = await _dbHelper.getRecipeCount();
      if (count == 0) {
        final fetched = await _api.fetchRecipes(startIdx: 1, endIdx: 1000);
        await _dbHelper.insertRecipes(fetched);
      }
      _allRecipes = await _dbHelper.getAllRecipes();
      errorMessage = null;
    } catch (e) {
      errorMessage = '레시피 데이터를 불러오지 못했습니다: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  // 선택된 재료 이름 리스트를 받아서 매칭 수행
  void recommend(List<String> selectedIngredientNames) {
    print('=== 디버그 ===');
    print('전체 레시피 수: ${_allRecipes.length}');
    print('선택한 재료: $selectedIngredientNames');
    if (_allRecipes.isNotEmpty) {
      print('첫 번째 레시피: ${_allRecipes[0].name}');
      print('첫 번째 레시피 재료: ${_allRecipes[0].ingredientNames}');
    }
    
    final selectedSet = selectedIngredientNames.toSet();
    final results = <RecipeMatchResult>[];

    for (final recipe in _allRecipes) {
      final matched = recipe.ingredientNames
          .where((name) => selectedSet.contains(name))
          .toList();

      if (matched.isEmpty) continue; // 하나도 안 겹치면 추천 대상에서 제외

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

    // 매칭률 높은 순 정렬
    results.sort((a, b) => b.matchRate.compareTo(a.matchRate));

    _matchResults = results;
    notifyListeners();
  }
}

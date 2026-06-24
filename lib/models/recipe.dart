class Recipe {
  final String id;
  final String name; // 메뉴명 (RCP_NM)
  final List<String> ingredientNames; // 재료명 리스트 (파싱된 형태)
  final String cookingSteps; // 조리과정 합본 텍스트
  final String imageUrl; // 대표 이미지
  final String? calorie; // 칼로리 정보 (INFO_ENG)

  Recipe({
    required this.id,
    required this.name,
    required this.ingredientNames,
    required this.cookingSteps,
    required this.imageUrl,
    this.calorie,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] as String,
      name: map['name'] as String,
      ingredientNames: (map['ingredientNames'] as String)
          .split(',')
          .where((e) => e.trim().isNotEmpty)
          .toList(),
      cookingSteps: map['cookingSteps'] as String,
      imageUrl: map['imageUrl'] as String,
      calorie: map['calorie'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ingredientNames': ingredientNames.join(','),
      'cookingSteps': cookingSteps,
      'imageUrl': imageUrl,
      'calorie': calorie,
    };
  }
}

// 매칭 결과를 담는 보조 클래스
class RecipeMatchResult {
  final Recipe recipe;
  final List<String> matchedIngredients; // 보유한 재료
  final List<String> missingIngredients; // 부족한 재료

  RecipeMatchResult({
    required this.recipe,
    required this.matchedIngredients,
    required this.missingIngredients,
  });

  // 매칭률 (0.0 ~ 1.0)
  double get matchRate {
    final total = recipe.ingredientNames.length;
    if (total == 0) return 0;
    return matchedIngredients.length / total;
  }
}

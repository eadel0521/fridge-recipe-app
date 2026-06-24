enum IngredientCategory {
  vegetable,
  meat,
  seafood,
  dairy,
  grain,
  seasoning,
  etc;

  String get label {
    switch (this) {
      case IngredientCategory.vegetable: return '채소';
      case IngredientCategory.meat:      return '육류';
      case IngredientCategory.seafood:   return '수산물';
      case IngredientCategory.dairy:     return '유제품';
      case IngredientCategory.grain:     return '곡류';
      case IngredientCategory.seasoning: return '양념/조미료';
      case IngredientCategory.etc:       return '기타';
    }
  }
}

class Ingredient {
  final String id;
  final String name;
  final IngredientCategory category;
  bool isSelected;

  Ingredient({
    required this.id,
    required this.name,
    required this.category,
    this.isSelected = false,
  });
}

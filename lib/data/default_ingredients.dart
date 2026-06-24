import '../models/ingredient.dart';

// 카테고리별 기본 재료 목록 (체크박스로 보여줄 고정 리스트)
// 추후 필요하면 항목 추가/수정하면 됩니다.
List<Ingredient> getDefaultIngredients() {
  final data = <String, List<String>>{
    'vegetable': [
      '양파', '대파', '마늘', '감자', '당근', '애호박', '배추', '무',
      '콩나물', '시금치', '버섯', '고추', '깻잎', '상추', '오이', '토마토',
    ],
    'meat': [
      '돼지고기', '소고기', '닭고기', '베이컨', '소시지', '햄',
    ],
    'seafood': [
      '고등어', '오징어', '새우', '멸치', '김', '미역', '명태',
    ],
    'dairy': [
      '계란', '우유', '치즈', '버터', '요거트',
    ],
    'grain': [
      '쌀', '밀가루', '식빵', '국수', '떡',
    ],
    'seasoning': [
      '간장', '고추장', '된장', '소금', '설탕', '식초', '참기름', '들기름',
      '고춧가루', '후추',
    ],
    'etc': [
      '두부', '김치', '식용유',
    ],
  };

  final categoryMap = {
    'vegetable': IngredientCategory.vegetable,
    'meat': IngredientCategory.meat,
    'seafood': IngredientCategory.seafood,
    'dairy': IngredientCategory.dairy,
    'grain': IngredientCategory.grain,
    'seasoning': IngredientCategory.seasoning,
    'etc': IngredientCategory.etc,
  };

  final List<Ingredient> result = [];
  int idCounter = 1;

  data.forEach((key, names) {
    final category = categoryMap[key]!;
    for (final name in names) {
      result.add(
        Ingredient(
          id: 'ing_${idCounter++}',
          name: name,
          category: category,
        ),
      );
    }
  });

  return result;
}

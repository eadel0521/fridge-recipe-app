import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeApi {
  // TODO: 발급받은 인증키로 교체
  static const String apiKey = 'cbec2b8491c44bc08d70';
  static const String baseUrl = 'http://openapi.foodsafetykorea.go.kr/api';
  static const String serviceId = 'COOKRCP01';

  Future<List<Recipe>> fetchRecipes({
    int startIdx = 1,
    int endIdx = 100,
  }) async {
    final url = Uri.parse(
      '$baseUrl/$apiKey/$serviceId/json/$startIdx/$endIdx',
    );

    // ignore: avoid_print
    print('API 호출 URL: $url');

    try {
      final response = await http.get(url);

      // ignore: avoid_print
      print('응답 코드: ${response.statusCode}');
      // ignore: avoid_print
      print('응답 앞부분: ${response.body.length > 200 ? response.body.substring(0, 200) : response.body}');

      if (response.statusCode != 200) {
        throw Exception('레시피 API 호출 실패: ${response.statusCode}');
      }

      final body = json.decode(utf8.decode(response.bodyBytes));
      final rows = body[serviceId]?['row'] as List<dynamic>?;

      // ignore: avoid_print
      print('파싱된 레시피 수: ${rows?.length ?? 0}');

      if (rows == null) return [];

      return rows.map((row) => _parseRow(row)).toList();
    } catch (e) {
      // ignore: avoid_print
      print('API 오류: $e');
      return [];
    }
  }

  Recipe _parseRow(Map<String, dynamic> row) {
    final rawIngredients = (row['RCP_PARTS_DTLS'] ?? '') as String;
    final parsedIngredients = _extractIngredientNames(rawIngredients);

    final steps = <String>[];
    for (int i = 1; i <= 20; i++) {
      final key = 'MANUAL${i.toString().padLeft(2, '0')}';
      final step = row[key];
      if (step != null && (step as String).trim().isNotEmpty) {
        steps.add(step.trim());
      }
    }

    return Recipe(
      id: row['RCP_SEQ']?.toString() ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: row['RCP_NM'] ?? '',
      ingredientNames: parsedIngredients,
      cookingSteps: steps.join('\n'),
      imageUrl: row['ATT_FILE_NO_MAIN'] ?? '',
      calorie: row['INFO_ENG']?.toString(),
    );
  }

  List<String> _extractIngredientNames(String raw) {
    if (raw.trim().isEmpty) return [];

    final parts = raw.split(RegExp(r'[,\n]'));
    final names = <String>[];

    for (var part in parts) {
      part = part.trim();
      if (part.isEmpty) continue;
      final firstToken = part.split(' ').first;
      final cleaned = firstToken.replaceAll(RegExp(r'[^가-힣a-zA-Z]'), '');
      if (cleaned.isNotEmpty) {
        names.add(cleaned);
      }
    }

    return names;
  }
}

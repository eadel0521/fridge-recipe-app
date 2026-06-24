import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recipe.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fridge_recipe.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE recipes (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            ingredientNames TEXT NOT NULL,
            cookingSteps TEXT NOT NULL,
            imageUrl TEXT,
            calorie TEXT
          )
        ''');
      },
    );
  }

  // 레시피 여러 건 저장 (API에서 받아온 데이터 캐싱용)
  Future<void> insertRecipes(List<Recipe> recipes) async {
    final db = await database;
    final batch = db.batch();
    for (final recipe in recipes) {
      batch.insert(
        'recipes',
        recipe.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // 전체 레시피 조회
  Future<List<Recipe>> getAllRecipes() async {
    final db = await database;
    final maps = await db.query('recipes');
    return maps.map((m) => Recipe.fromMap(m)).toList();
  }

  // 저장된 레시피 개수 확인 (초기 동기화 필요 여부 판단용)
  Future<int> getRecipeCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM recipes');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> clearRecipes() async {
    final db = await database;
    await db.delete('recipes');
  }
}

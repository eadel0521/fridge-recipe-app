import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';  
import 'providers/ingredient_provider.dart';
import 'providers/recommend_provider.dart';
import 'screens/ingredient_select_screen.dart';

void main() {
  // Windows/Linux/macOS에서 sqflite 초기화
  if (!kIsWeb) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IngredientProvider()),
        ChangeNotifierProvider(
          create: (_) => RecommendProvider()..initRecipes(),
        ),
      ],
      child: MaterialApp(
        title: '냉장고 메뉴 추천',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.green,
          useMaterial3: true,
        ),
        home: const IngredientSelectScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/ingredient_provider.dart';
import 'providers/recommend_provider.dart';
import 'screens/ingredient_select_screen.dart';

void main() {
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

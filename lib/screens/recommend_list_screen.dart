import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recommend_provider.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class RecommendListScreen extends StatelessWidget {
  const RecommendListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recommendProvider = context.watch<RecommendProvider>();
    final results = recommendProvider.matchResults;

    return Scaffold(
      appBar: AppBar(title: const Text('추천 메뉴')),
      body: results.isEmpty
          ? const Center(child: Text('추천 가능한 메뉴가 없어요.\n재료를 더 선택해보세요.'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return RecipeCard(
                  result: result,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(result: result),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ingredient_provider.dart';
import '../providers/recommend_provider.dart';
import '../widgets/ingredient_checkbox_tile.dart';
import 'recommend_list_screen.dart';

class IngredientSelectScreen extends StatefulWidget {
  const IngredientSelectScreen({super.key});

  @override
  State<IngredientSelectScreen> createState() =>
      _IngredientSelectScreenState();
}

class _IngredientSelectScreenState extends State<IngredientSelectScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';

  @override
  Widget build(BuildContext context) {
    final ingredientProvider = context.watch<IngredientProvider>();
    final searchResults = ingredientProvider.search(_searchKeyword);
    final grouped = ingredientProvider.groupedByCategory;
    final selectedCount = ingredientProvider.selectedIngredients.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('보유 재료 선택'),
        actions: [
          TextButton(
            onPressed: ingredientProvider.clearSelection,
            child: const Text('초기화', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: '재료 검색 (예: 양파)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => _searchKeyword = value);
              },
            ),
          ),
          Expanded(
            child: _searchKeyword.trim().isNotEmpty
                ? ListView(
                    children: searchResults
                        .map(
                          (ing) => IngredientCheckboxTile(
                            ingredient: ing,
                            onTap: () =>
                                ingredientProvider.toggleSelection(ing.id),
                          ),
                        )
                        .toList(),
                  )
                : ListView(
                    children: grouped.entries.map((entry) {
                      return ExpansionTile(
                        title: Text(entry.key.label),
                        initiallyExpanded: false,
                        children: entry.value
                            .map(
                              (ing) => IngredientCheckboxTile(
                                ingredient: ing,
                                onTap: () => ingredientProvider
                                    .toggleSelection(ing.id),
                              ),
                            )
                            .toList(),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: selectedCount == 0
                ? null
                : () {
                    final names = ingredientProvider.selectedIngredients
                        .map((e) => e.name)
                        .toList();
                    context.read<RecommendProvider>().recommend(names);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RecommendListScreen(),
                      ),
                    );
                  },
            child: Text('선택한 재료로 메뉴 추천받기 ($selectedCount)'),
          ),
        ),
      ),
    );
  }
}

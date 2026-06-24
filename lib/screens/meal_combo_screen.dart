import 'package:flutter/material.dart';

// 부가기능2: 추천된 메뉴들을 조합해서 최종 식단(예: 밥+국+반찬)을 구성해주는 화면
// TODO: 매칭률 상위 메뉴들을 카테고리(밥/국/반찬 등)로 분류해서 조합 로직 구현 필요
class MealComboScreen extends StatelessWidget {
  const MealComboScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('오늘의 식단 조합')),
      body: const Center(
        child: Text('식단 조합 추천 기능은 추후 구현 예정입니다.'),
      ),
    );
  }
}

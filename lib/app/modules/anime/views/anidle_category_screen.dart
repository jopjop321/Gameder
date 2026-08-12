import 'package:flutter/material.dart';
import 'package:gameder/app/data/models/category_model.dart';
import 'package:gameder/app/modules/anime/theme/anidle_theme.dart';
import 'package:gameder/app/modules/anime/views/anidle_screen.dart';
import 'package:gameder/widgets/responsive_category_grid.dart';
import 'package:get/get.dart';

class AnidleCategoryScreen extends StatelessWidget {
  const AnidleCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAnimeBgColor,
      appBar: AppBar(
        title: Text('category_animeDifficulty'.tr),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ResponsiveCategoryGrid(
          categories: anidleCategories,
          onCardTap: _openQuiz,
        ),
      ),
    );
  }

  void _openQuiz(GameCategory category) {
    final difficultyId = category.gameId;
    if (difficultyId == null) return;

    Get.to(
      () => AnidleScreen(
        difficultyId: difficultyId,
        title: category.displayTitle,
      ),
    );
  }
}

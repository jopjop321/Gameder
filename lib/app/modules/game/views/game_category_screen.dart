import 'package:flutter/material.dart';
import 'package:gameder/app/data/models/category_model.dart';
import 'package:gameder/app/modules/game/theme/gamedle_theme.dart';
import 'package:gameder/app/modules/game/views/gamedle_screen.dart';
import 'package:gameder/widgets/responsive_category_grid.dart';
import 'package:get/get.dart';

class GameCategoryScreen extends StatelessWidget {
  const GameCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGameBgColor,
      appBar: AppBar(
        title: Text('category_gameMenu'.tr),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ResponsiveCategoryGrid(
          categories: gameCategories,
          onCardTap: _openQuiz,
        ),
      ),
    );
  }

  void _openQuiz(GameCategory category) {
    final platformId = category.gameId;
    if (platformId == null) return;

    Get.to(
      () => GamedleScreen(platformId: platformId, title: category.displayTitle),
    );
  }
}

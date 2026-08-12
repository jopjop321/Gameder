import 'package:flutter/material.dart';
import 'package:gameder/app/data/models/category_model.dart';
import 'package:gameder/app/modules/movie/theme/moviedle_theme.dart';
import 'package:gameder/app/modules/movie/views/moviedle_screen.dart';
import 'package:gameder/widgets/responsive_category_grid.dart';
import 'package:get/get.dart';

class MovieCategoryScreen extends StatelessWidget {
  const MovieCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMovieBgColor,
      appBar: AppBar(
        title: Text('category_movieMenu'.tr),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ResponsiveCategoryGrid(
          categories: movieCategories,
          onCardTap: _openQuiz,
        ),
      ),
    );
  }

  void _openQuiz(GameCategory category) {
    final collectionId = category.gameId;
    if (collectionId == null) return;

    Get.to(
      () => MoviedleScreen(collectionId: collectionId, title: category.displayTitle),
    );
  }
}

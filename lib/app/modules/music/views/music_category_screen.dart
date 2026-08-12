import 'package:flutter/material.dart';
import 'package:gameder/app/data/models/category_model.dart';
import 'package:gameder/app/modules/music/theme/musicdle_theme.dart';
import 'package:gameder/app/modules/music/views/musicdle_screen.dart';
import 'package:gameder/widgets/responsive_category_grid.dart';
import 'package:get/get.dart';

class MusicCategoryScreen extends StatelessWidget {
  const MusicCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMusicBgColor,
      appBar: AppBar(
        title: Text('category_musicMenu'.tr),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ResponsiveCategoryGrid(
          categories: musicCategories,
          onCardTap: _openQuiz,
        ),
      ),
    );
  }

  void _openQuiz(GameCategory category) {
    final collectionId = category.gameId;
    if (collectionId == null) return;

    Get.to(
      () => MusicdleScreen(collectionId: collectionId, title: category.displayTitle),
    );
  }
}

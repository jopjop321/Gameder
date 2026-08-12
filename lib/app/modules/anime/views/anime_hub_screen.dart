import 'package:flutter/material.dart';
import 'package:gameder/app/data/models/category_model.dart';
import 'package:gameder/app/modules/anime/theme/anidle_theme.dart';
import 'package:gameder/app/modules/anime/views/anidle_category_screen.dart';
import 'package:gameder/app/modules/reborn/views/reborndle_screen.dart';
import 'package:gameder/widgets/responsive_category_grid.dart';
import 'package:get/get.dart';

class AnimeHubScreen extends StatelessWidget {
  const AnimeHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAnimeBgColor,
      appBar: AppBar(
        title: Text('category_animeHub'.tr),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ResponsiveCategoryGrid(
          categories: animeHubCategories,
          onCardTap: _openGame,
        ),
      ),
    );
  }

  void _openGame(GameCategory category) {
    switch (category.gameType) {
      case 'anime_menu':
        Get.to(() => const AnidleCategoryScreen());
        break;
      case 'reborn':
        Get.to(() => const ReborndleScreen());
        break;
    }
  }
}

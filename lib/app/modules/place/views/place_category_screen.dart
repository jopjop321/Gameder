import 'package:flutter/material.dart';
import 'package:gameder/app/data/models/category_model.dart';
import 'package:gameder/app/modules/place/theme/placedle_theme.dart';
import 'package:gameder/app/modules/place/views/placedle_screen.dart';
import 'package:gameder/widgets/responsive_category_grid.dart';
import 'package:get/get.dart';

class PlaceCategoryScreen extends StatelessWidget {
  const PlaceCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPlaceBgColor,
      appBar: AppBar(
        title: Text('category_placeMenu'.tr),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ResponsiveCategoryGrid(
          categories: placeCategories,
          onCardTap: _openQuiz,
        ),
      ),
    );
  }

  void _openQuiz(GameCategory category) {
    final regionId = category.gameId;
    if (regionId == null) return;

    Get.to(
      () => PlacedleScreen(regionId: regionId, title: category.displayTitle),
    );
  }
}

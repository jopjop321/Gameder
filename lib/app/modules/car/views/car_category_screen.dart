import 'package:flutter/material.dart';
import 'package:gameder/app/data/models/category_model.dart';
import 'package:gameder/app/modules/car/theme/cardle_theme.dart';
import 'package:gameder/app/modules/car/views/cardle_screen.dart';
import 'package:gameder/widgets/responsive_category_grid.dart';
import 'package:get/get.dart';

class CarCategoryScreen extends StatelessWidget {
  const CarCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCarBgColor,
      appBar: AppBar(
        title: Text('category_carMenu'.tr),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ResponsiveCategoryGrid(
          categories: carCategories,
          onCardTap: _openQuiz,
        ),
      ),
    );
  }

  void _openQuiz(GameCategory category) {
    final collectionId = category.gameId;
    if (collectionId == null) return;

    Get.to(
      () => CardleScreen(collectionId: collectionId, title: category.displayTitle),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gameder/app/data/models/category_model.dart';
import 'package:gameder/app/modules/food/theme/foodle_theme.dart';
import 'package:gameder/app/modules/food/views/foodle_screen.dart';
import 'package:gameder/widgets/responsive_category_grid.dart';
import 'package:get/get.dart';

class FoodCategoryScreen extends StatelessWidget {
  const FoodCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFoodBgColor,
      appBar: AppBar(
        title: Text('category_foodMenu'.tr),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ResponsiveCategoryGrid(
          categories: foodCategories,
          onCardTap: _openQuiz,
        ),
      ),
    );
  }

  void _openQuiz(GameCategory category) {
    final regionId = category.gameId;
    if (regionId == null) return;

    Get.to(
      () => FoodleScreen(regionId: regionId, title: category.displayTitle),
    );
  }
}

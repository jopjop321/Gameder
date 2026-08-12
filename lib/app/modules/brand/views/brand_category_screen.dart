import 'package:flutter/material.dart';
import 'package:gameder/app/data/models/category_model.dart';
import 'package:gameder/app/modules/brand/theme/branddle_theme.dart';
import 'package:gameder/app/modules/brand/views/branddle_screen.dart';
import 'package:gameder/widgets/responsive_category_grid.dart';
import 'package:get/get.dart';

class BrandCategoryScreen extends StatelessWidget {
  const BrandCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrandBgColor,
      appBar: AppBar(
        title: Text('category_brandMenu'.tr),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ResponsiveCategoryGrid(
          categories: brandCategories,
          onCardTap: _openQuiz,
        ),
      ),
    );
  }

  void _openQuiz(GameCategory category) {
    final collectionId = category.gameId;
    if (collectionId == null) return;

    Get.to(
      () => BranddleScreen(collectionId: collectionId, title: category.displayTitle),
    );
  }
}

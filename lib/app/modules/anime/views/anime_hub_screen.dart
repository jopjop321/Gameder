import 'package:flutter/material.dart';
import 'package:gameder/app/data/models/category_model.dart';
import 'package:gameder/app/modules/anime/theme/anidle_theme.dart';
import 'package:gameder/app/modules/anime/views/anidle_category_screen.dart';
import 'package:gameder/app/modules/reborn/views/reborndle_screen.dart';
import 'package:gameder/app/modules/onepiece/views/onepiecedle_screen.dart';
import 'package:gameder/app/modules/naruto/views/narutodle_screen.dart';
import 'package:gameder/app/modules/aot/views/titandle_screen.dart';
import 'package:gameder/app/modules/demonslayer/views/kimetsudle_screen.dart';
import 'package:gameder/app/modules/mha/views/herodle_screen.dart';
import 'package:gameder/app/modules/blackclover/views/cloverdle_screen.dart';
import 'package:gameder/app/modules/bleach/views/bleachdle_screen.dart';
import 'package:gameder/app/modules/fairytail/views/fairydle_screen.dart';
import 'package:gameder/app/modules/hxh/views/hunterdle_screen.dart';
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
      case 'onepiece':
        Get.to(() => const OnepiecedleScreen());
        break;
      case 'naruto':
        Get.to(() => const NarutodleScreen());
        break;
      case 'aot':
        Get.to(() => const TitandleScreen());
        break;
      case 'demonslayer':
        Get.to(() => const KimetsudleScreen());
        break;
      case 'mha':
        Get.to(() => const HerodleScreen());
        break;
      case 'blackclover':
        Get.to(() => const CloverdleScreen());
        break;
      case 'bleach':
        Get.to(() => const BleachdleScreen());
        break;
      case 'fairytail':
        Get.to(() => const FairydleScreen());
        break;
      case 'hxh':
        Get.to(() => const HunterdleScreen());
        break;
    }
  }
}

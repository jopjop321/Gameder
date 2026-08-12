import 'package:get/get.dart';
import 'package:gameder/app/data/models/category_model.dart';
import 'package:gameder/app/modules/pokedle_screen/views/pokedle_screen.dart';
import 'package:gameder/app/modules/food/views/foodle_screen.dart';
import 'package:gameder/app/modules/place/views/placedle_screen.dart';
import 'package:gameder/app/modules/celebrity/views/celebritydle_screen.dart';
import 'package:gameder/app/modules/anime/views/anidle_screen.dart';
import 'package:gameder/app/modules/reborn/views/reborndle_screen.dart';
import 'package:gameder/app/modules/game/views/gamedle_screen.dart';
import 'package:gameder/app/modules/movie/views/moviedle_screen.dart';
import 'package:gameder/app/modules/car/views/cardle_screen.dart';
import 'package:gameder/app/modules/music/views/musicdle_screen.dart';
import 'package:gameder/app/modules/brand/views/branddle_screen.dart';

/// Opens the actual game screen for a leaf-level [GameCategory] topic,
/// skipping any category-selection screen. Shared by Home's ยอดนิยม/ใหม่
/// tabs and the search screen so both jump straight into the same games.
void openTopic(GameCategory category) {
  switch (category.gameType) {
    case 'pokedle':
      Get.to(() => GameScreen(genFile: category.genFile ?? 'gen1'));
      break;
    case 'food_quiz':
      final regionId = category.gameId;
      if (regionId == null) return;
      Get.to(
        () => FoodleScreen(regionId: regionId, title: category.displayTitle),
      );
      break;
    case 'place_quiz':
      final regionId = category.gameId;
      if (regionId == null) return;
      Get.to(
        () => PlacedleScreen(regionId: regionId, title: category.displayTitle),
      );
      break;
    case 'celebrity_quiz':
      final collectionId = category.gameId;
      if (collectionId == null) return;
      Get.to(
        () => CelebritydleScreen(
          collectionId: collectionId,
          title: category.displayTitle,
        ),
      );
      break;
    case 'anime_quiz':
      final difficultyId = category.gameId;
      if (difficultyId == null) return;
      Get.to(
        () => AnidleScreen(
          difficultyId: difficultyId,
          title: category.displayTitle,
        ),
      );
      break;
    case 'reborn':
      Get.to(() => const ReborndleScreen());
      break;
    case 'game_quiz':
      final platformId = category.gameId;
      if (platformId == null) return;
      Get.to(
        () => GamedleScreen(platformId: platformId, title: category.displayTitle),
      );
      break;
    case 'movie_quiz':
      final collectionId = category.gameId;
      if (collectionId == null) return;
      Get.to(
        () => MoviedleScreen(
          collectionId: collectionId,
          title: category.displayTitle,
        ),
      );
      break;
    case 'car_quiz':
      final collectionId = category.gameId;
      if (collectionId == null) return;
      Get.to(
        () => CardleScreen(
          collectionId: collectionId,
          title: category.displayTitle,
        ),
      );
      break;
    case 'music_quiz':
      final collectionId = category.gameId;
      if (collectionId == null) return;
      Get.to(
        () => MusicdleScreen(
          collectionId: collectionId,
          title: category.displayTitle,
        ),
      );
      break;
    case 'brand_quiz':
      final collectionId = category.gameId;
      if (collectionId == null) return;
      Get.to(
        () => BranddleScreen(
          collectionId: collectionId,
          title: category.displayTitle,
        ),
      );
      break;
    default:
      Get.snackbar(
        'common_comingSoonTitle'.tr,
        'common_notPlayableYet'.trParams({'title': category.displayTitle}),
      );
  }
}

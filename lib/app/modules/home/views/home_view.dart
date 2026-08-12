import 'package:gameder/constants/imports.dart';
import 'package:gameder/app/modules/food/views/food_category_screen.dart';
import 'package:gameder/app/modules/anime/views/anime_hub_screen.dart';
import 'package:gameder/app/modules/place/views/place_category_screen.dart';
import 'package:gameder/app/modules/celebrity/views/celebrity_category_screen.dart';
import 'package:gameder/app/modules/game/views/game_category_screen.dart';
import 'package:gameder/app/modules/movie/views/movie_category_screen.dart';
import 'package:gameder/app/modules/car/views/car_category_screen.dart';
import 'package:gameder/app/modules/music/views/music_category_screen.dart';
import 'package:gameder/app/modules/brand/views/brand_category_screen.dart';
import 'package:gameder/app/modules/search/views/search_screen.dart';
import 'package:gameder/app/modules/settings/views/settings_screen.dart';
import 'package:gameder/app/routing/topic_navigator.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: kAppBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              const _HomeTopBar(),
              const _HomeTabBar(),
              Expanded(
                child: TabBarView(
                  children: [
                    ResponsiveCategoryGrid(
                      categories: popularTopics,
                      onCardTap: openTopic,
                    ),
                    ResponsiveCategoryGrid(
                      categories: mockCategories,
                      onCardTap: _handleCategoryTap,
                    ),
                    ResponsiveCategoryGrid(
                      categories: newTopics,
                      onCardTap: openTopic,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Top-level category cards shown under the "หมวดหมู่" tab.
  void _handleCategoryTap(GameCategory category) {
    switch (category.gameType) {
      case 'pokedle_menu':
        Get.to(() => PokedleCategoryScreen());
        break;
      case 'food_menu':
        Get.to(() => const FoodCategoryScreen());
        break;
      case 'anime_hub':
        Get.to(() => const AnimeHubScreen());
        break;
      case 'place_menu':
        Get.to(() => const PlaceCategoryScreen());
        break;
      case 'celebrity_menu':
        Get.to(() => const CelebrityCategoryScreen());
        break;
      case 'game_menu':
        Get.to(() => const GameCategoryScreen());
        break;
      case 'movie_menu':
        Get.to(() => const MovieCategoryScreen());
        break;
      case 'car_menu':
        Get.to(() => const CarCategoryScreen());
        break;
      case 'music_menu':
        Get.to(() => const MusicCategoryScreen());
        break;
      case 'brand_menu':
        Get.to(() => const BrandCategoryScreen());
        break;
      default:
        Get.snackbar(
          'common_comingSoonTitle'.tr,
          'common_notPlayableYet'.trParams({'title': category.displayTitle}),
        );
    }
  }
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            tooltip: 'common_search'.tr,
            onPressed: () => Get.to(() => const SearchScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            tooltip: 'common_settings'.tr,
            onPressed: () => Get.to(() => const SettingsScreen()),
          ),
        ],
      ),
    );
  }
}

class _HomeTabBar extends StatelessWidget {
  const _HomeTabBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.all(4),
        child: TabBar(
          indicator: BoxDecoration(
            color: Colors.white.withOpacity(0.16),
            borderRadius: BorderRadius.circular(24),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          splashBorderRadius: BorderRadius.circular(24),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: 'home_tabPopular'.tr),
            Tab(text: 'home_tabCategories'.tr),
            Tab(text: 'home_tabNew'.tr),
          ],
        ),
      ),
    );
  }
}

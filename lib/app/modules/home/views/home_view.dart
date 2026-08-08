import 'package:gameder/constants/imports.dart';
import 'package:gameder/app/modules/food/views/food_category_screen.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppBackgroundColor,
      body: SafeArea(
        child: ResponsiveCategoryGrid(
          categories: mockCategories,
          onCardTap: _handleCardTap,
        ),
      ),
    );
  }

  void _handleCardTap(GameCategory category) {
    switch (category.gameType) {
      case 'pokedle_menu':
        Get.to(() => PokedleCategoryScreen());
        break;
      case 'pokedle':
        Get.to(() => GameScreen(genFile: category.genFile ?? 'gen1'));
        break;
      case 'food_menu':
        Get.to(() => const FoodCategoryScreen());
        break;
      default:
        Get.snackbar('เร็วๆ นี้', '${category.title} ยังไม่เปิดให้เล่นครับ');
    }
  }
}

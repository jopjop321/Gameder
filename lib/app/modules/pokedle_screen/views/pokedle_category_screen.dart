import 'package:gameder/constants/imports.dart';

class PokedleCategoryScreen extends StatelessWidget {
  const PokedleCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppBackgroundColor,
      appBar: AppBar(
        title: Text('category_pokedleChooseGen'.tr),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ResponsiveCategoryGrid(
          categories: pokedleCategories,
          onCardTap: (category) {
            Get.to(() => GameScreen(genFile: category.genFile ?? 'gen1'));
          },
        ),
      ),
    );
  }
}
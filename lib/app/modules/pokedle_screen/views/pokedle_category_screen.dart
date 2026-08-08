import 'package:gameder/constants/imports.dart';

class PokedleCategoryScreen extends StatelessWidget {
  const PokedleCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppBackgroundColor,
      appBar: AppBar(
        title: const Text('เลือก Generation'),
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
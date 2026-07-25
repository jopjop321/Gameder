import 'package:gameder/constants/imports.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD35400),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;

            int crossAxisCount = 2;
            double childAspectRatio = 0.90;

            if (width >= 1024) {
              crossAxisCount = 4;
              childAspectRatio = 1.0;
            } else if (width >= 600) {
              crossAxisCount = 3;
              childAspectRatio = 0.95;
            } else {
              crossAxisCount = 2;
              childAspectRatio = 0.90;
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: mockCategories.length,
              itemBuilder: (context, index) {
                final category = mockCategories[index];
                return CategoryCardItem(
                  category: category,
                  onTap: () =>
                      _handleCardTap(category), // 👈 แยกฟังก์ชันไว้ให้อ่านง่าย
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _handleCardTap(GameCategory category) {
  switch (category.gameType) {
    case 'pokedle_menu':
      // พาไปหน้าเลือกหมวดหมู่ย่อยของ Pokedle
      Get.to(() => PokedleCategoryScreen());
      break;
    case 'pokedle':
      // พาไปหน้าเล่นเกม Pokedle พร้อมส่ง genFile ไปให้
      Get.to(() => GameScreen(genFile: category.genFile ?? 'gen1'));
      break;
    default:
      Get.snackbar('เร็วๆ นี้', '${category.title} ยังไม่เปิดให้เล่นครับ');
  }
}
}

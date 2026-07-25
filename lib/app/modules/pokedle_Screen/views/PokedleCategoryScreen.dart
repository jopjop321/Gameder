import 'package:gameder/constants/imports.dart';

class PokedleCategoryScreen extends StatelessWidget {
  const PokedleCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD35400), // สีพื้นหลังแบบเดียวกัน
      appBar: AppBar(
        title: const Text('เลือก Generation'),
        backgroundColor: Colors.transparent, // ปรับตามดีไซน์
        elevation: 0,
      ),
      body: SafeArea(
        // ใช้ Widget ตัวเดียวกันเป๊ะ!
        child: ResponsiveCategoryGrid(
          categories: pokedleCategories, // เปลี่ยนเป็นลิสต์ของ Gen 1, 2, 3
          onCardTap: (category) {
             // โลจิกเมื่อกดการ์ด Gen
             Get.to(() => GameScreen(genFile: category.genFile ?? 'gen1'));
          },
        ),
      ),
    );
  }
}
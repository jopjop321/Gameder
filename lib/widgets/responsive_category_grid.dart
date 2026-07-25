import 'package:gameder/constants/imports.dart';
// import GameCategory และ CategoryCardItem ของคุณมาด้วย

class ResponsiveCategoryGrid extends StatelessWidget {
  final List<GameCategory> categories; // รับข้อมูล List ที่จะแสดง
  final Function(GameCategory) onCardTap; // รับฟังก์ชันเมื่อกดการ์ด

  const ResponsiveCategoryGrid({
    super.key,
    required this.categories,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCardItem(
              category: category,
              onTap: () => onCardTap(category), // ส่ง event กลับไปให้หน้าที่เรียกใช้งาน
            );
          },
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:gameder/widgets/category_card_item.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // List categories = ["sdfsdf","sdfsdf"];
    return Scaffold(
      backgroundColor: const Color(0xFFD35400), // สีส้มอิฐตามธีม
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;

            // คำนวณจำนวนคอลัมน์และสัดส่วนตามขนาดหน้าจอ (Responsive)
            int crossAxisCount = 2;
            double childAspectRatio = 0.90;

            if (width >= 1024) {
              crossAxisCount = 4; // Web
              childAspectRatio = 1.0;
            } else if (width >= 600) {
              crossAxisCount = 3; // Tablet / iPad
              childAspectRatio = 0.95;
            } else {
              crossAxisCount = 2; // Mobile
              childAspectRatio = 0.90;
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              // ดึงจำนวน Item จาก controller
              itemCount: controller.mockCategories.length,
              itemBuilder: (context, index) {
                final category = controller.mockCategories[index];
                return CategoryCardItem(
                  category: category,
                  onTap: () => controller.onCategorySelected(category), // เรียกใช้ Logic ผ่าน controller
                );
              },
            );
          },
        ),
      ),
    );
  }
}

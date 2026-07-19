import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    List categories = ["sdfsdf","sdfsdf"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter GetX Counter'),
      ),
      body: Center(
        child:  GridView.builder(
  padding: const EdgeInsets.all(16.0),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,         // 3 คอลัมน์ตามรูป
    crossAxisSpacing: 12.0,    // ระยะห่างแนวนอน
    mainAxisSpacing: 12.0,     // ระยะห่างแนวตั้ง
    childAspectRatio: 0.95,    // สัดส่วนความสูง (ปรับให้เหมาะกับรูปทรง)
  ),
  itemCount: categories.length,
  itemBuilder: (context, index) {
    return GestureDetector(
      onTap: () {
        print("เลือกหมวดหมู่: ${categories[index].title}");
      },
      child: Container(
        // 1. ทำขอบสีขาวหนาๆ และมุมโค้งรอบตัวการ์ด
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0), // ความโค้งมนสูงแบบในรูป
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 4), // เงาลงด้านล่างเพิ่มมิติ
            ),
          ],
        ),
        padding: const EdgeInsets.all(6.0), // ความหนาของขอบสีขาว
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.0), // โค้งมนตามขอบด้านใน
          child: Stack(
            children: [
              // 2. ส่วนของรูปภาพพื้นหลัง/ตัวการ์ตูน
              Positioned.fill(
                child: Image.asset(
                  categories[index].imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              // 3. ข้อความหมวดหมู่ด้านบนรูปภาพ
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Text(
                  categories[index].title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: categories[index].textColor, // ปรับสีให้ตัดกับพื้นหลัง
                    shadows: const [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.black26,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
)
      ),
      // floatingActionButton: FloatingActionButton(
      //   // เรียกใช้ฟังก์ชันผ่าน controller โดยตรง
      //   onPressed: controller.incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

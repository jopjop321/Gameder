import 'package:get/get.dart';

class HomeController extends GetxController {
  // ประกาศตัวแปรเฝ้าดู (.obs) แทน int ธรรมดา
  var counter = 0.obs;

  // ฟังก์ชันคำนวณ Logic
  void incrementCounter() {
    counter.value++; // เพิ่มค่าผ่าน .value
  }
}
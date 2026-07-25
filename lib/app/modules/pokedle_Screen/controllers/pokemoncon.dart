import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PokemonController extends GetxController {
  List<dynamic> allPokemonList = [];

  @override
  void onInit() {
    super.onInit();
    
    // 1. รับค่า genFile ที่ส่งมา (เช่น 'gen1', 'all')
    String? genFile = Get.arguments as String?; 
    
    // 2. แปลง genFile เป็น Array ของ path ไฟล์
    List<String> filesToLoad = _getFilePathsByGen(genFile);
    
    // 3. เรียกฟังก์ชันอ่านไฟล์
    loadMultipleJsonFiles(filesToLoad);
  }

  // ฟังก์ชันตัวช่วย: แมปค่า String เป็น Array ไฟล์ที่ต้องการ
  List<String> _getFilePathsByGen(String? genType) {
    switch (genType) {
      case 'gen1':
        return ['assets/data/gen1.json'];
      case 'gen2':
        return ['assets/data/gen2.json'];
      case 'gen3':
        return ['assets/data/gen3.json'];
      case 'all':
        // ถ้าเป็น 'all' ก็โยน array ไฟล์ทั้งหมดไปเลย
        return [
          'assets/data/gen1.json',
          'assets/data/gen2.json',
          'assets/data/gen3.json',
        ];
      default:
        // ค่า Default กันเหนียว
        return ['assets/data/gen1.json']; 
    }
  }

  // ฟังก์ชันอ่านไฟล์ (โค้ดเดิมของคุณเลยครับ)
  Future<void> loadMultipleJsonFiles(List<String> filePaths) async {
    try {
      allPokemonList.clear(); 

      for (String path in filePaths) {
        String data = await rootBundle.loadString(path);
        List<dynamic> jsonList = jsonDecode(data);
        allPokemonList.addAll(jsonList); 
      }

      update(); 
      print('โหลดข้อมูลสำเร็จ รวม: ${allPokemonList.length} ตัว');

    } catch (e) {
      print('Error โหลด JSON: $e');
    }
  }
}
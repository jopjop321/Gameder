import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/data/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Gameder",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}


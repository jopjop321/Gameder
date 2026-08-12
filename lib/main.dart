import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/data/routes/app_pages.dart';
import 'app/data/services/locale_service.dart';
import 'app/translations/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final locale = await LocaleService.loadSavedLocale();

  runApp(
    GetMaterialApp(
      title: "Gameder",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      translations: AppTranslations(),
      locale: locale,
      fallbackLocale: LocaleService.defaultLocale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

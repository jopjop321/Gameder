import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gameder/app/data/routes/app_pages.dart';
import 'package:gameder/app/data/services/locale_service.dart';
import 'package:gameder/app/translations/app_translations.dart';

void main() {
  testWidgets('App boots to the home screen without throwing', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final locale = await LocaleService.loadSavedLocale();

    await tester.pumpWidget(
      GetMaterialApp(
        title: "Gameder",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        translations: AppTranslations(),
        locale: locale,
        fallbackLocale: LocaleService.defaultLocale,
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        debugShowCheckedModeBanner: false,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsWidgets);
  });
}

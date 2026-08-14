import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:gameder/app/modules/onepiece/views/onepiecedle_screen.dart';
import 'package:gameder/app/modules/onepiece/widgets/onepiecedle_guess_row.dart';
import 'package:gameder/app/translations/app_translations.dart';

/// Pumps a bounded number of frames instead of pumpAndSettle: the guess
/// table's flip animations and CachedNetworkImage's retry timers never
/// fully settle under the test binding's fake HTTP client.
Future<void> _pumpFrames(WidgetTester tester, [int times = 15]) async {
  for (var i = 0; i < times; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('Onepiecedle loads characters and evaluates a guess', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(
        translations: AppTranslations(),
        locale: const Locale('en', 'US'),
        fallbackLocale: const Locale('en', 'US'),
        home: const OnepiecedleScreen(),
      ),
    );

    // rootBundle.loadString needs a real event-loop turn to resolve the
    // asset read under the test binding.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 500)),
    );
    await _pumpFrames(tester);

    // Loading finished and the search field is visible.
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(TextField), findsOneWidget);

    // Search for a well-known character and confirm the dataset loaded it.
    await tester.enterText(find.byType(TextField), 'Luffy');
    await _pumpFrames(tester);

    final suggestion = find.text('Monkey D. Luffy');
    expect(suggestion, findsWidgets);

    // Submitting the guess renders an evaluated row in the table.
    await tester.tap(suggestion.first);
    await _pumpFrames(tester);

    expect(find.byType(OnepiecedleGuessRow), findsOneWidget);

    // Giving up reveals the answer banner.
    await tester.tap(find.text('Give up'));
    await _pumpFrames(tester);

    expect(find.textContaining('The answer was'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kFoodBgColor = kAppBackgroundColor;
const Color kFoodPanelColor = Color(0xFF163B4D);
const Color kFoodHeaderCellColor = Color(0xFF1C4E63);
const Color kFoodAccentColor = Color(0xFFFFC857);
const Color kFoodCorrectColor = Color(0xFF238636);
const Color kFoodPartialColor = Color(0xFFC98A00);
const Color kFoodIncorrectColor = Color(0xFF475569);

const List<String> kFoodColumnLabels = [
  'เมนู',
  'ประเทศ',
  'ประเภท',
  'วัตถุดิบ',
  'วิธีปรุง',
  'รสชาติ',
  'เผ็ด',
];

/// Thai game only: 'ภาค' is inserted right after 'ประเทศ'.
List<String> foodColumnLabels({bool includeRegion = false}) {
  if (!includeRegion) return kFoodColumnLabels;
  return [
    kFoodColumnLabels[0],
    kFoodColumnLabels[1],
    'ภาค',
    ...kFoodColumnLabels.skip(2),
  ];
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kFoodBgColor = kAppBackgroundColor;
const Color kFoodPanelColor = Color(0xFF163B4D);
const Color kFoodHeaderCellColor = Color(0xFF1C4E63);
const Color kFoodAccentColor = Color(0xFFFFC857);
const Color kFoodCorrectColor = Color(0xFF238636);
const Color kFoodPartialColor = Color(0xFFC98A00);
const Color kFoodIncorrectColor = Color(0xFF475569);

/// Thai game only: 'col_foodRegion' is inserted right after 'col_foodCountry'.
List<String> foodColumnLabels({bool includeRegion = false}) {
  final labels = [
    'col_foodMenu'.tr,
    'col_foodCountry'.tr,
    'col_foodType'.tr,
    'col_foodIngredient'.tr,
    'col_foodCookingMethod'.tr,
    'col_foodFlavor'.tr,
    'col_foodSpiceLevel'.tr,
  ];
  if (!includeRegion) return labels;
  return [
    labels[0],
    labels[1],
    'col_foodRegion'.tr,
    ...labels.skip(2),
  ];
}

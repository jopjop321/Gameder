import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kPlaceBgColor = kAppBackgroundColor;
const Color kPlacePanelColor = Color(0xFF1E3D2F);
const Color kPlaceHeaderCellColor = Color(0xFF2A5940);
const Color kPlaceAccentColor = Color(0xFF7FD858);
const Color kPlaceCorrectColor = Color(0xFF238636);
const Color kPlacePartialColor = Color(0xFFC98A00);
const Color kPlaceIncorrectColor = Color(0xFF475569);

/// Thailand game only: 'col_placeRegion' is inserted right after 'col_placeCountry'.
List<String> placeColumnLabels({bool includeRegion = false}) {
  final labels = [
    'col_placeName'.tr,
    'col_placeCountry'.tr,
    'col_placeType'.tr,
    'col_placeHighlight'.tr,
    'col_placeActivity'.tr,
    'col_placeHighlights'.tr,
    'col_placeCost'.tr,
  ];
  if (!includeRegion) return labels;
  return [
    labels[0],
    labels[1],
    'col_placeRegion'.tr,
    ...labels.skip(2),
  ];
}

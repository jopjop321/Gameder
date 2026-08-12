import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kGameBgColor = kAppBackgroundColor;
const Color kGamePanelColor = Color(0xFF163B4D);
const Color kGameHeaderCellColor = Color(0xFF1C4E63);
const Color kGameAccentColor = Color(0xFFFFC857);
const Color kGameCorrectColor = Color(0xFF238636);
const Color kGamePartialColor = Color(0xFFC98A00);
const Color kGameIncorrectColor = Color(0xFF475569);

List<String> gameColumnLabels() => [
      'col_gameName'.tr,
      'col_gameDeveloper'.tr,
      'col_gameCountry'.tr,
      'col_gameGenre'.tr,
      'col_gamePlatforms'.tr,
      'col_gameReleaseYear'.tr,
      'col_gameMode'.tr,
      'col_gameAgeRating'.tr,
    ];

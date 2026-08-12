import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kAnimeBgColor = kAppBackgroundColor;
const Color kAnimePanelColor = Color(0xFF2A1B4D);
const Color kAnimeHeaderCellColor = Color(0xFF3D2A63);
const Color kAnimeAccentColor = Color(0xFFB388FF);
const Color kAnimeCorrectColor = Color(0xFF238636);
const Color kAnimePartialColor = Color(0xFFC98A00);
const Color kAnimeIncorrectColor = Color(0xFF475569);

List<String> animeColumnLabels() => [
      'col_animeTitle'.tr,
      'col_animeStudio'.tr,
      'col_animeTargetAudience'.tr,
      'col_animeFormat'.tr,
      'col_animeSource'.tr,
      'col_animeGenre'.tr,
      'col_animeReleaseYear'.tr,
      'col_animeProtagonistGender'.tr,
    ];

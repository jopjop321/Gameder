import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kMusicBgColor = kAppBackgroundColor;
const Color kMusicPanelColor = Color(0xFF4D1E3A);
const Color kMusicHeaderCellColor = Color(0xFF66294D);
const Color kMusicAccentColor = Color(0xFFFF4FA3);
const Color kMusicCorrectColor = Color(0xFF238636);
const Color kMusicPartialColor = Color(0xFFC98A00);
const Color kMusicIncorrectColor = Color(0xFF475569);

List<String> musicColumnLabels() => [
      'col_musicName'.tr,
      'col_musicArtist'.tr,
      'col_musicCountry'.tr,
      'col_musicGenre'.tr,
      'col_musicReleaseYear'.tr,
      'col_musicLabel'.tr,
    ];

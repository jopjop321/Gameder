import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kCelebrityBgColor = kAppBackgroundColor;
const Color kCelebrityPanelColor = Color(0xFF3B1E4D);
const Color kCelebrityHeaderCellColor = Color(0xFF4E1C63);
const Color kCelebrityAccentColor = Color(0xFFFFC857);
const Color kCelebrityCorrectColor = Color(0xFF238636);
const Color kCelebrityPartialColor = Color(0xFFC98A00);
const Color kCelebrityIncorrectColor = Color(0xFF475569);

/// 'all' mode: 'col_celebrityOccupation' is inserted right after
/// 'col_celebrityName'. 'youtuber' mode: swaps in the richer
/// YouTuber-only column set.
List<String> celebrityColumnLabels({
  bool includeOccupation = false,
  bool includeYoutuberFields = false,
}) {
  if (includeYoutuberFields) {
    return [
      'col_celebrityName'.tr,
      'col_celebrityGenre'.tr,
      'col_celebrityChannelType'.tr,
      'col_celebrityGender'.tr,
      'col_celebritySubscribers'.tr,
      'col_celebrityYearFamous'.tr,
      'col_celebrityRegion'.tr,
      'col_celebrityAffiliation'.tr,
    ];
  }
  final labels = [
    'col_celebrityName'.tr,
    'col_celebrityGender'.tr,
    'col_celebrityGenre'.tr,
    'col_celebrityRegion'.tr,
    'col_celebrityAffiliation'.tr,
    'col_celebrityYearFamous'.tr,
  ];
  if (!includeOccupation) return labels;
  return [
    labels[0],
    'col_celebrityOccupation'.tr,
    ...labels.skip(1),
  ];
}

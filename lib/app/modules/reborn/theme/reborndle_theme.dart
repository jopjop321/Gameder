import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kRebornBgColor = kAppBackgroundColor;
const Color kRebornPanelColor = Color(0xFF3B1220);
const Color kRebornHeaderCellColor = Color(0xFF5C1A2E);
const Color kRebornAccentColor = Color(0xFFFFB74D);
const Color kRebornCorrectColor = Color(0xFF238636);
const Color kRebornPartialColor = Color(0xFFC98A00);
const Color kRebornIncorrectColor = Color(0xFF475569);

List<String> rebornColumnLabels() => [
      'col_rebornName'.tr,
      'col_rebornFamily'.tr,
      'col_rebornFlame'.tr,
      'col_rebornPosition'.tr,
      'col_rebornBoxWeapon'.tr,
      'col_rebornWeapon'.tr,
      'col_rebornRace'.tr,
      'col_rebornGender'.tr,
      'col_rebornArc'.tr,
    ];

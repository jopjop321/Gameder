import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kAotBgColor = kAppBackgroundColor;
const Color kAotPanelColor = Color(0xFF23241C);
const Color kAotHeaderCellColor = Color(0xFF3B3A2E);
const Color kAotAccentColor = Color(0xFFB5834B);
const Color kAotCorrectColor = Color(0xFF238636);
const Color kAotPartialColor = Color(0xFFC98A00);
const Color kAotIncorrectColor = Color(0xFF475569);

List<String> aotColumnLabels() => [
      'col_aotName'.tr,
      'col_aotAffiliation'.tr,
      'col_aotTitanType'.tr,
      'col_aotRank'.tr,
      'col_aotWeapon'.tr,
      'col_aotSpecies'.tr,
      'col_aotGender'.tr,
      'col_aotOrigin'.tr,
      'col_aotSaga'.tr,
    ];

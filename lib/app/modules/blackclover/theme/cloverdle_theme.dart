import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kBlackcloverBgColor = kAppBackgroundColor;
const Color kBlackcloverPanelColor = Color(0xFF141110);
const Color kBlackcloverHeaderCellColor = Color(0xFF241D18);
const Color kBlackcloverAccentColor = Color(0xFFD4AF37);
const Color kBlackcloverCorrectColor = Color(0xFF238636);
const Color kBlackcloverPartialColor = Color(0xFFC98A00);
const Color kBlackcloverIncorrectColor = Color(0xFF475569);

List<String> blackcloverColumnLabels() => [
      'col_blackcloverName'.tr,
      'col_blackcloverSquad'.tr,
      'col_blackcloverMagicType'.tr,
      'col_blackcloverGrimoire'.tr,
      'col_blackcloverRole'.tr,
      'col_blackcloverWeapon'.tr,
      'col_blackcloverGender'.tr,
      'col_blackcloverKingdom'.tr,
      'col_blackcloverSaga'.tr,
    ];

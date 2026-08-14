import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kDemonslayerBgColor = kAppBackgroundColor;
const Color kDemonslayerPanelColor = Color(0xFF0E1512);
const Color kDemonslayerHeaderCellColor = Color(0xFF16241F);
const Color kDemonslayerAccentColor = Color(0xFF7FE0C4);
const Color kDemonslayerCorrectColor = Color(0xFF238636);
const Color kDemonslayerPartialColor = Color(0xFFC98A00);
const Color kDemonslayerIncorrectColor = Color(0xFF475569);

List<String> demonslayerColumnLabels() => [
      'col_demonslayerName'.tr,
      'col_demonslayerCorps'.tr,
      'col_demonslayerBreathingStyle'.tr,
      'col_demonslayerRank'.tr,
      'col_demonslayerSpecies'.tr,
      'col_demonslayerWeapon'.tr,
      'col_demonslayerGender'.tr,
      'col_demonslayerSwordColor'.tr,
      'col_demonslayerSaga'.tr,
    ];

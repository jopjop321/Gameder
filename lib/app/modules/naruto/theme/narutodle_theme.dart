import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kNarutoBgColor = kAppBackgroundColor;
const Color kNarutoPanelColor = Color(0xFF1A1206);
const Color kNarutoHeaderCellColor = Color(0xFF3A2410);
const Color kNarutoAccentColor = Color(0xFFFF8C00);
const Color kNarutoCorrectColor = Color(0xFF238636);
const Color kNarutoPartialColor = Color(0xFFC98A00);
const Color kNarutoIncorrectColor = Color(0xFF475569);

List<String> narutoColumnLabels() => [
      'col_narutoName'.tr,
      'col_narutoVillage'.tr,
      'col_narutoClan'.tr,
      'col_narutoChakraNature'.tr,
      'col_narutoRank'.tr,
      'col_narutoTeam'.tr,
      'col_narutoWeapon'.tr,
      'col_narutoGender'.tr,
      'col_narutoBijuu'.tr,
      'col_narutoSaga'.tr,
    ];

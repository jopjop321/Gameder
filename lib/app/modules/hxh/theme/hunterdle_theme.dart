import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kHxhBgColor = kAppBackgroundColor;
const Color kHxhPanelColor = Color(0xFF0D2618);
const Color kHxhHeaderCellColor = Color(0xFF163B26);
const Color kHxhAccentColor = Color(0xFF3DDC84);
const Color kHxhCorrectColor = Color(0xFF238636);
const Color kHxhPartialColor = Color(0xFFC98A00);
const Color kHxhIncorrectColor = Color(0xFF475569);

List<String> hxhColumnLabels() => [
      'col_hxhName'.tr,
      'col_hxhAffiliation'.tr,
      'col_hxhNenType'.tr,
      'col_hxhLicense'.tr,
      'col_hxhRole'.tr,
      'col_hxhWeapon'.tr,
      'col_hxhGender'.tr,
      'col_hxhHatsuName'.tr,
      'col_hxhSaga'.tr,
    ];

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kBrandBgColor = kAppBackgroundColor;
const Color kBrandPanelColor = Color(0xFF1E4D4D);
const Color kBrandHeaderCellColor = Color(0xFF2A6666);
const Color kBrandAccentColor = Color(0xFF26C6DA);
const Color kBrandCorrectColor = Color(0xFF238636);
const Color kBrandPartialColor = Color(0xFFC98A00);
const Color kBrandIncorrectColor = Color(0xFF475569);

List<String> brandColumnLabels() => [
      'col_brandName'.tr,
      'col_brandIndustry'.tr,
      'col_brandCountry'.tr,
      'col_brandHeadquartersCity'.tr,
      'col_brandOwnershipType'.tr,
      'col_brandParentCompany'.tr,
      'col_brandFoundedYear'.tr,
    ];

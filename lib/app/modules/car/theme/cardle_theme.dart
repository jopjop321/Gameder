import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kCarBgColor = kAppBackgroundColor;
const Color kCarPanelColor = Color(0xFF1E2A4D);
const Color kCarHeaderCellColor = Color(0xFF2A3A66);
const Color kCarAccentColor = Color(0xFF4FC3F7);
const Color kCarCorrectColor = Color(0xFF238636);
const Color kCarPartialColor = Color(0xFFC98A00);
const Color kCarIncorrectColor = Color(0xFF475569);

List<String> carColumnLabels() => [
      'col_carName'.tr,
      'col_carBrand'.tr,
      'col_carCountry'.tr,
      'col_carBodyType'.tr,
      'col_carFuelType'.tr,
      'col_carPriceSegment'.tr,
      'col_carLaunchYear'.tr,
    ];

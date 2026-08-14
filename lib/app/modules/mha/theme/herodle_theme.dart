import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color kMhaBgColor = Color(0xFF10131A);
const Color kMhaPanelColor = Color(0xFF1B1030);
const Color kMhaHeaderCellColor = Color(0xFF2A1245);
const Color kMhaAccentColor = Color(0xFFE62429);
const Color kMhaCorrectColor = Color(0xFF238636);
const Color kMhaPartialColor = Color(0xFFC98A00);
const Color kMhaIncorrectColor = Color(0xFF475569);

List<String> mhaColumnLabels() => [
      'col_mhaName'.tr,
      'col_mhaAffiliation'.tr,
      'col_mhaQuirkType'.tr,
      'col_mhaQuirkName'.tr,
      'col_mhaRole'.tr,
      'col_mhaWeapon'.tr,
      'col_mhaGender'.tr,
      'col_mhaHeroName'.tr,
      'col_mhaSaga'.tr,
    ];

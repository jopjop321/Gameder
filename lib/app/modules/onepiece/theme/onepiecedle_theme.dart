import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kOnePieceBgColor = kAppBackgroundColor;
const Color kOnePiecePanelColor = Color(0xFF0D2436);
const Color kOnePieceHeaderCellColor = Color(0xFF123B57);
const Color kOnePieceAccentColor = Color(0xFFFFC531);
const Color kOnePieceCorrectColor = Color(0xFF238636);
const Color kOnePiecePartialColor = Color(0xFFC98A00);
const Color kOnePieceIncorrectColor = Color(0xFF475569);

List<String> onePieceColumnLabels() => [
      'col_onepieceName'.tr,
      'col_onepieceCrew'.tr,
      'col_onepieceDevilFruitType'.tr,
      'col_onepieceDevilFruitName'.tr,
      'col_onepieceRole'.tr,
      'col_onepieceWeapon'.tr,
      'col_onepieceSpecies'.tr,
      'col_onepieceGender'.tr,
      'col_onepieceBounty'.tr,
      'col_onepieceSaga'.tr,
    ];

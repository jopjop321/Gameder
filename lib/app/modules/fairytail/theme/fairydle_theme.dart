import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kFairytailBgColor = kAppBackgroundColor;
const Color kFairytailPanelColor = Color(0xFF241B36);
const Color kFairytailHeaderCellColor = Color(0xFF3A2A57);
const Color kFairytailAccentColor = Color(0xFFFF6FA0);
const Color kFairytailCorrectColor = Color(0xFF238636);
const Color kFairytailPartialColor = Color(0xFFC98A00);
const Color kFairytailIncorrectColor = Color(0xFF475569);

List<String> fairytailColumnLabels() => [
      'col_fairytailName'.tr,
      'col_fairytailGuild'.tr,
      'col_fairytailMagicType'.tr,
      'col_fairytailTeam'.tr,
      'col_fairytailGuildRank'.tr,
      'col_fairytailWeapon'.tr,
      'col_fairytailGender'.tr,
      'col_fairytailGuildMarkColor'.tr,
      'col_fairytailSaga'.tr,
    ];

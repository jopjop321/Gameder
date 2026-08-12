import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gameder/constants/app_colors.dart';

const Color kMovieBgColor = kAppBackgroundColor;
const Color kMoviePanelColor = Color(0xFF4D1E1E);
const Color kMovieHeaderCellColor = Color(0xFF6B2B2B);
const Color kMovieAccentColor = Color(0xFFFF7043);
const Color kMovieCorrectColor = Color(0xFF238636);
const Color kMoviePartialColor = Color(0xFFC98A00);
const Color kMovieIncorrectColor = Color(0xFF475569);

List<String> movieColumnLabels() => [
      'col_movieName'.tr,
      'col_movieDirector'.tr,
      'col_movieCountry'.tr,
      'col_movieGenre'.tr,
      'col_movieReleaseYear'.tr,
      'col_movieStudio'.tr,
      'col_movieFranchise'.tr,
      'col_movieAgeRating'.tr,
    ];

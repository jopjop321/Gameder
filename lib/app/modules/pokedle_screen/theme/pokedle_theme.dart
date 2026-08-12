import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color kBgColor = Color(0xFF1A1A2E);
const Color kCardColor = Color(0xFF232342);
const Color kCorrectColor = Color(0xFF2ECC71);
const Color kPartialColor = Color(0xFFE67E22);
const Color kWrongColor = Color(0xFFE74C3C);
const Color kAccentColor = Color(0xFF9D4EDD);

/// English placeholder purely for [kColumnLabels.length]; the header row
/// renders [pokedleColumnLabels] instead, which is locale-aware.
const List<String> kColumnLabels = [
  'Pokémon',
  'Type 1',
  'Type 2',
  'Evo Stage',
  'Fully Evolved',
  'Color',
  'Habitat',
  'Gen',
];

List<String> pokedleColumnLabels() => [
      'col_pokemon'.tr,
      'col_pokemonType1'.tr,
      'col_pokemonType2'.tr,
      'col_pokemonEvoStage'.tr,
      'col_pokemonFullyEvolved'.tr,
      'col_pokemonColor'.tr,
      'col_pokemonHabitat'.tr,
      'col_pokemonGen'.tr,
    ];

const double kCellWidth = 84;
const double kCellHMargin = 2;
const double kColumnSlotWidth = kCellWidth + kCellHMargin * 2;
final double kTableContentWidth = kColumnSlotWidth * kColumnLabels.length;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameCategory {
  /// Translation key (or, for brand names like 'Pokedle', the literal
  /// string itself — `.tr` passes unknown keys through unchanged).
  final String title;
  final Map<String, String>? titleArgs;
  final String? imagePath;
  final IconData? icon;
  final Color textColor;
  final String gameType;

  /// Pokedle only: 'gen1', 'gen2', ..., or 'all'.
  final String? genFile;
  final String? gameId;

  const GameCategory({
    required this.title,
    required this.textColor,
    required this.gameType,
    this.titleArgs,
    this.imagePath,
    this.icon,
    this.genFile,
    this.gameId,
  }) : assert(imagePath != null || icon != null);

  /// Resolves [title] through the current locale's translations.
  String get displayTitle =>
      titleArgs != null ? title.trParams(titleArgs!) : title.tr;
}

final List<GameCategory> mockCategories = [
  GameCategory(
    title: 'Pokedle',
    imagePath: 'assets/images/pikachi.png',
    textColor: Colors.black,
    gameType: 'pokedle_menu',
    genFile: 'pokedle_menu',
  ),
  GameCategory(
    title: 'category_foodMenu',
    imagePath: 'assets/images/food.png',
    textColor: Colors.black,
    gameType: 'food_menu',
  ),
  const GameCategory(
    title: 'category_animeHub',
    icon: Icons.movie_filter_outlined,
    textColor: Colors.white,
    gameType: 'anime_hub',
  ),
  const GameCategory(
    title: 'category_placeMenu',
    icon: Icons.travel_explore_outlined,
    textColor: Colors.white,
    gameType: 'place_menu',
  ),
  const GameCategory(
    title: 'category_celebrityMenu',
    icon: Icons.star_outline,
    textColor: Colors.white,
    gameType: 'celebrity_menu',
  ),
  const GameCategory(
    title: 'category_gameMenu',
    icon: Icons.sports_esports_outlined,
    textColor: Colors.white,
    gameType: 'game_menu',
  ),
  const GameCategory(
    title: 'category_movieMenu',
    icon: Icons.local_movies_outlined,
    textColor: Colors.white,
    gameType: 'movie_menu',
  ),
  const GameCategory(
    title: 'category_carMenu',
    icon: Icons.directions_car_outlined,
    textColor: Colors.white,
    gameType: 'car_menu',
  ),
  const GameCategory(
    title: 'category_musicMenu',
    icon: Icons.music_note_outlined,
    textColor: Colors.white,
    gameType: 'music_menu',
  ),
  const GameCategory(
    title: 'category_brandMenu',
    icon: Icons.branding_watermark_outlined,
    textColor: Colors.white,
    gameType: 'brand_menu',
  ),
  // GameCategory(title: 'ความรู้ทั่วไป', ... gameType: 'trivia'),
];

/// Sub-categories for the Anime hub screen (Anidle, Reborndle, ...).
final List<GameCategory> animeHubCategories = [
  const GameCategory(
    title: 'Anidle',
    icon: Icons.movie_filter_outlined,
    textColor: Colors.white,
    gameType: 'anime_menu',
  ),
  const GameCategory(
    title: 'Reborndle',
    icon: Icons.local_fire_department_outlined,
    textColor: Colors.white,
    gameType: 'reborn',
  ),
  const GameCategory(
    title: 'Onepiecedle',
    icon: Icons.sailing_outlined,
    textColor: Colors.white,
    gameType: 'onepiece',
  ),
  const GameCategory(
    title: 'Narutodle',
    icon: Icons.filter_vintage_outlined,
    textColor: Colors.white,
    gameType: 'naruto',
  ),
  const GameCategory(
    title: 'Titandle',
    icon: Icons.shield_outlined,
    textColor: Colors.white,
    gameType: 'aot',
  ),
  const GameCategory(
    title: 'Kimetsudle',
    icon: Icons.water_drop_outlined,
    textColor: Colors.white,
    gameType: 'demonslayer',
  ),
  const GameCategory(
    title: 'Herodle',
    icon: Icons.bolt_outlined,
    textColor: Colors.white,
    gameType: 'mha',
  ),
  const GameCategory(
    title: 'Cloverdle',
    icon: Icons.eco_outlined,
    textColor: Colors.white,
    gameType: 'blackclover',
  ),
  const GameCategory(
    title: 'Bleachdle',
    icon: Icons.dark_mode_outlined,
    textColor: Colors.white,
    gameType: 'bleach',
  ),
  const GameCategory(
    title: 'Fairydle',
    icon: Icons.auto_awesome_outlined,
    textColor: Colors.white,
    gameType: 'fairytail',
  ),
  const GameCategory(
    title: 'Hunterdle',
    icon: Icons.forest_outlined,
    textColor: Colors.white,
    gameType: 'hxh',
  ),
];

/// Sub-categories for the Pokedle selection screen.
final List<GameCategory> pokedleCategories = [
  const GameCategory(
    title: 'category_pokedleAllGens',
    imagePath: 'assets/images/pikachi.png',
    textColor: Colors.black,
    gameType: 'pokedle',
    genFile: 'all',
  ),
  ...List.generate(
    9,
    (i) => GameCategory(
      title: 'Pokedle Gen ${i + 1}',
      imagePath: 'assets/images/pikachi.png',
      textColor: Colors.black,
      gameType: 'pokedle',
      genFile: 'gen${i + 1}',
    ),
  ),
];

final List<GameCategory> foodCategories = [
  const GameCategory(
    title: 'food_thai',
    imagePath: 'assets/images/food.png',
    textColor: Colors.black,
    gameType: 'food_quiz',
    gameId: 'thai',
  ),
  const GameCategory(
    title: 'food_japanese',
    imagePath: 'assets/images/food.png',
    textColor: Colors.black,
    gameType: 'food_quiz',
    gameId: 'japanese',
  ),
  const GameCategory(
    title: 'food_chinese',
    imagePath: 'assets/images/food.png',
    textColor: Colors.black,
    gameType: 'food_quiz',
    gameId: 'chinese',
  ),
  const GameCategory(
    title: 'food_european',
    imagePath: 'assets/images/food.png',
    textColor: Colors.black,
    gameType: 'food_quiz',
    gameId: 'european',
  ),
  const GameCategory(
    title: 'food_world',
    imagePath: 'assets/images/food.png',
    textColor: Colors.black,
    gameType: 'food_quiz',
    gameId: 'world',
  ),
  const GameCategory(
    title: 'food_southeastAsia',
    imagePath: 'assets/images/food.png',
    textColor: Colors.black,
    gameType: 'food_quiz',
    gameId: 'southeast_asia',
  ),
];

final List<GameCategory> gameCategories = [
  const GameCategory(
    title: 'game_mobile',
    icon: Icons.phone_android_outlined,
    textColor: Colors.white,
    gameType: 'game_quiz',
    gameId: 'mobile',
  ),
  const GameCategory(
    title: 'game_pc',
    icon: Icons.computer_outlined,
    textColor: Colors.white,
    gameType: 'game_quiz',
    gameId: 'pc',
  ),
  const GameCategory(
    title: 'game_nintendo',
    icon: Icons.videogame_asset_outlined,
    textColor: Colors.white,
    gameType: 'game_quiz',
    gameId: 'nintendo',
  ),
  const GameCategory(
    title: 'game_all',
    icon: Icons.all_inclusive,
    textColor: Colors.white,
    gameType: 'game_quiz',
    gameId: 'all',
  ),
];

/// Sub-categories for the Placedle (tourist places) selection screen.
final List<GameCategory> placeCategories = [
  const GameCategory(
    title: 'place_thailand',
    icon: Icons.temple_buddhist_outlined,
    textColor: Colors.white,
    gameType: 'place_quiz',
    gameId: 'thailand',
  ),
  const GameCategory(
    title: 'place_world',
    icon: Icons.public_outlined,
    textColor: Colors.white,
    gameType: 'place_quiz',
    gameId: 'world',
  ),
];

/// Sub-categories for the Anidle difficulty selection screen.
final List<GameCategory> anidleCategories = [
  const GameCategory(
    title: 'difficulty_easy',
    icon: Icons.sentiment_satisfied_alt,
    textColor: Colors.white,
    gameType: 'anime_quiz',
    gameId: 'easy',
  ),
  const GameCategory(
    title: 'difficulty_medium',
    icon: Icons.sentiment_neutral,
    textColor: Colors.white,
    gameType: 'anime_quiz',
    gameId: 'medium',
  ),
  const GameCategory(
    title: 'difficulty_hard',
    icon: Icons.sentiment_very_dissatisfied,
    textColor: Colors.white,
    gameType: 'anime_quiz',
    gameId: 'hard',
  ),
  const GameCategory(
    title: 'common_all',
    icon: Icons.all_inclusive,
    textColor: Colors.white,
    gameType: 'anime_quiz',
    gameId: 'all',
  ),
];

/// Sub-categories for the celebrity ("คนดัง") selection screen.
final List<GameCategory> celebrityCategories = [
  const GameCategory(
    title: 'common_all',
    icon: Icons.public,
    textColor: Colors.white,
    gameType: 'celebrity_quiz',
    gameId: 'all',
  ),
  const GameCategory(
    title: 'celebrity_youtuber',
    icon: Icons.smart_display_outlined,
    textColor: Colors.white,
    gameType: 'celebrity_quiz',
    gameId: 'youtuber',
  ),
  const GameCategory(
    title: 'celebrity_youtuberGlobal',
    icon: Icons.public,
    textColor: Colors.white,
    gameType: 'celebrity_quiz',
    gameId: 'global_youtuber',
  ),
  const GameCategory(
    title: 'celebrity_actor',
    icon: Icons.theater_comedy_outlined,
    textColor: Colors.white,
    gameType: 'celebrity_quiz',
    gameId: 'actor',
  ),
  const GameCategory(
    title: 'celebrity_singer',
    icon: Icons.mic_external_on_outlined,
    textColor: Colors.white,
    gameType: 'celebrity_quiz',
    gameId: 'singer',
  ),
  const GameCategory(
    title: 'celebrity_athlete',
    icon: Icons.sports_soccer_outlined,
    textColor: Colors.white,
    gameType: 'celebrity_quiz',
    gameId: 'athlete',
  ),
  const GameCategory(
    title: 'celebrity_kpopIdol',
    icon: Icons.music_note_outlined,
    textColor: Colors.white,
    gameType: 'celebrity_quiz',
    gameId: 'kpop_idol',
  ),
  const GameCategory(
    title: 'celebrity_ySeriesActor',
    icon: Icons.favorite_border,
    textColor: Colors.white,
    gameType: 'celebrity_quiz',
    gameId: 'y_series_actor',
  ),
  const GameCategory(
    title: 'celebrity_koreanActor',
    icon: Icons.local_movies_outlined,
    textColor: Colors.white,
    gameType: 'celebrity_quiz',
    gameId: 'korean_actor',
  ),
];

/// Sub-categories for the Movie ("ภาพยนตร์") selection screen.
final List<GameCategory> movieCategories = [
  const GameCategory(
    title: 'common_all',
    icon: Icons.local_movies_outlined,
    textColor: Colors.white,
    gameType: 'movie_quiz',
    gameId: 'all',
  ),
];

/// Sub-categories for the Car ("รถยนต์") selection screen.
final List<GameCategory> carCategories = [
  const GameCategory(
    title: 'common_all',
    icon: Icons.directions_car_outlined,
    textColor: Colors.white,
    gameType: 'car_quiz',
    gameId: 'all',
  ),
];

/// Sub-categories for the Music ("เพลง") selection screen.
final List<GameCategory> musicCategories = [
  const GameCategory(
    title: 'common_all',
    icon: Icons.music_note_outlined,
    textColor: Colors.white,
    gameType: 'music_quiz',
    gameId: 'all',
  ),
];

/// Sub-categories for the Brand ("แบรนด์") selection screen.
final List<GameCategory> brandCategories = [
  const GameCategory(
    title: 'common_all',
    icon: Icons.branding_watermark_outlined,
    textColor: Colors.white,
    gameType: 'brand_quiz',
    gameId: 'all',
  ),
];

/// Curated leaf-level topics for the Home "ยอดนิยม" tab — mixed across every
/// game, not just top-level categories. Manually ranked for now; swap for
/// real play-count data once stats tracking exists.
final List<GameCategory> popularTopics = [
  pokedleCategories[0], // Gen 1-9 (all)
  foodCategories[0], // Thai food
  placeCategories[0], // Travel Thailand
  celebrityCategories[0], // All
  anidleCategories[3], // All
  foodCategories[1], // Japanese food
];

/// Every playable leaf-level topic across all games — used by the search
/// screen so it can look across the whole app, not just one category.
final List<GameCategory> allTopics = [
  ...pokedleCategories,
  ...foodCategories,
  ...anidleCategories,
  ...placeCategories,
  ...celebrityCategories,
  ...gameCategories,
  ...movieCategories,
  ...carCategories,
  ...musicCategories,
  ...brandCategories,
  animeHubCategories[1], // Reborndle
  animeHubCategories[2], // Onepiecedle
  animeHubCategories[3], // Narutodle
  animeHubCategories[4], // Titandle
  animeHubCategories[5], // Kimetsudle
  animeHubCategories[6], // Herodle
  animeHubCategories[7], // Cloverdle
  animeHubCategories[8], // Bleachdle
  animeHubCategories[9], // Fairydle
  animeHubCategories[10], // Hunterdle
];

/// Curated leaf-level topics for the Home "ใหม่" tab, newest first — mixed
/// across every game. Manually ordered for now; swap for real
/// "date added" data later.
final List<GameCategory> newTopics = [
  movieCategories[0], // Movies (just added)
  carCategories[0], // Cars (just added)
  musicCategories[0], // Music (just added)
  brandCategories[0], // Brands (just added)
  foodCategories[5], // Southeast Asian food
  animeHubCategories[3], // Narutodle (just added)
  animeHubCategories[4], // Titandle (just added)
  animeHubCategories[5], // Kimetsudle (just added)
  animeHubCategories[6], // Herodle (just added)
  animeHubCategories[7], // Cloverdle (just added)
  animeHubCategories[8], // Bleachdle (just added)
  animeHubCategories[9], // Fairydle (just added)
  animeHubCategories[10], // Hunterdle (just added)
];

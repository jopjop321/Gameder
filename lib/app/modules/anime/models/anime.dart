import 'package:get/get.dart';

class Anime {
  final String name;
  final String nameTh;
  final String nameJp;
  final String romajiJp;
  final List<String> genre;
  final String demographic;
  final String studio;
  final String format;
  final int releaseYear;
  final int episodeCount;
  final String sourceMaterial;
  final String setting;
  final String protagonistGender;
  final String? imageUrl;

  const Anime({
    required this.name,
    required this.nameTh,
    required this.nameJp,
    required this.romajiJp,
    required this.genre,
    required this.demographic,
    required this.studio,
    required this.format,
    required this.releaseYear,
    required this.episodeCount,
    required this.sourceMaterial,
    required this.setting,
    required this.protagonistGender,
    this.imageUrl,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      name: json['name'] as String,
      nameTh: json['name_th'] as String,
      nameJp: json['name_jp'] as String,
      romajiJp: json['romaji_jp'] as String,
      genre: (json['genre'] as List<dynamic>).cast<String>(),
      demographic: json['demographic'] as String,
      studio: json['studio'] as String,
      format: json['format'] as String,
      releaseYear: json['release_year'] as int,
      episodeCount: json['episode_count'] as int,
      sourceMaterial: json['source_material'] as String,
      setting: json['setting'] as String,
      protagonistGender: json['protagonist_gender'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }

  /// Name in the current app locale (Thai data already ships both).
  String get displayName => Get.locale?.languageCode == 'th' ? nameTh : name;

  bool matchesQuery(String query) {
    final normalized = query.trim().toLowerCase();
    return name.toLowerCase().contains(normalized) ||
        nameTh.contains(query.trim()) ||
        romajiJp.toLowerCase().contains(normalized);
  }
}

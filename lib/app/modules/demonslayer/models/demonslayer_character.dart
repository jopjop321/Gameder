import 'package:get/get.dart';

class DemonslayerCharacter {
  final String name;
  final String nameEn;
  final String corps;
  final String corpsEn;
  final String breathingStyle;
  final String breathingStyleEn;
  final String rank;
  final String rankEn;
  final String species;
  final String speciesEn;
  final String weaponType;
  final String weaponTypeEn;
  final String gender;
  final String genderEn;
  final String swordColor;
  final String swordColorEn;
  final String saga;
  final String sagaEn;
  final int sagaOrder;
  final String? imageUrl;

  const DemonslayerCharacter({
    required this.name,
    required this.nameEn,
    required this.corps,
    required this.corpsEn,
    required this.breathingStyle,
    required this.breathingStyleEn,
    required this.rank,
    required this.rankEn,
    required this.species,
    required this.speciesEn,
    required this.weaponType,
    required this.weaponTypeEn,
    required this.gender,
    required this.genderEn,
    required this.swordColor,
    required this.swordColorEn,
    required this.saga,
    required this.sagaEn,
    required this.sagaOrder,
    this.imageUrl,
  });

  factory DemonslayerCharacter.fromJson(Map<String, dynamic> json) {
    return DemonslayerCharacter(
      name: json['name'] as String,
      nameEn: json['name_en'] as String? ?? json['name'] as String,
      corps: json['corps'] as String,
      corpsEn: json['corps_en'] as String? ?? json['corps'] as String,
      breathingStyle: json['breathing_style'] as String,
      breathingStyleEn:
          json['breathing_style_en'] as String? ??
              json['breathing_style'] as String,
      rank: json['rank'] as String,
      rankEn: json['rank_en'] as String? ?? json['rank'] as String,
      species: json['species'] as String,
      speciesEn: json['species_en'] as String? ?? json['species'] as String,
      weaponType: json['weapon_type'] as String,
      weaponTypeEn:
          json['weapon_type_en'] as String? ?? json['weapon_type'] as String,
      gender: json['gender'] as String,
      genderEn: json['gender_en'] as String? ?? json['gender'] as String,
      swordColor: json['sword_color'] as String,
      swordColorEn:
          json['sword_color_en'] as String? ?? json['sword_color'] as String,
      saga: json['saga'] as String,
      sagaEn: json['saga_en'] as String? ?? json['saga'] as String,
      sagaOrder: json['saga_order'] as int,
      imageUrl: json['image_url'] as String?,
    );
  }

  bool get _isThai => Get.locale?.languageCode == 'th';

  /// Name in the current app locale.
  String get displayName => _isThai ? name : nameEn;
  String get displayCorps => _isThai ? corps : corpsEn;
  String get displayBreathingStyle =>
      _isThai ? breathingStyle : breathingStyleEn;
  String get displayRank => _isThai ? rank : rankEn;
  String get displaySpecies => _isThai ? species : speciesEn;
  String get displayWeaponType => _isThai ? weaponType : weaponTypeEn;
  String get displayGender => _isThai ? gender : genderEn;
  String get displaySwordColor => _isThai ? swordColor : swordColorEn;
  String get displaySaga => _isThai ? saga : sagaEn;

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    return name.toLowerCase().contains(q) || nameEn.toLowerCase().contains(q);
  }
}

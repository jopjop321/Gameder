import 'package:get/get.dart';

class RebornCharacter {
  final String name;
  final String nameEn;
  final String family;
  final String familyEn;
  final String flameAttribute;
  final String flameAttributeEn;
  final String role;
  final String roleEn;
  final String boxAnimal;
  final String boxAnimalEn;
  final String weaponType;
  final String weaponTypeEn;
  final String species;
  final String speciesEn;
  final String gender;
  final String genderEn;
  final String firstArc;
  final String firstArcEn;
  final int arcOrder;
  final String? imageUrl;

  const RebornCharacter({
    required this.name,
    required this.nameEn,
    required this.family,
    required this.familyEn,
    required this.flameAttribute,
    required this.flameAttributeEn,
    required this.role,
    required this.roleEn,
    required this.boxAnimal,
    required this.boxAnimalEn,
    required this.weaponType,
    required this.weaponTypeEn,
    required this.species,
    required this.speciesEn,
    required this.gender,
    required this.genderEn,
    required this.firstArc,
    required this.firstArcEn,
    required this.arcOrder,
    this.imageUrl,
  });

  factory RebornCharacter.fromJson(Map<String, dynamic> json) {
    return RebornCharacter(
      name: json['name'] as String,
      nameEn: json['name_en'] as String? ?? json['name'] as String,
      family: json['family'] as String,
      familyEn: json['family_en'] as String? ?? json['family'] as String,
      flameAttribute: json['flame_attribute'] as String,
      flameAttributeEn:
          json['flame_attribute_en'] as String? ??
              json['flame_attribute'] as String,
      role: json['role'] as String,
      roleEn: json['role_en'] as String? ?? json['role'] as String,
      boxAnimal: json['box_animal'] as String,
      boxAnimalEn: json['box_animal_en'] as String? ?? json['box_animal'] as String,
      weaponType: json['weapon_type'] as String,
      weaponTypeEn:
          json['weapon_type_en'] as String? ?? json['weapon_type'] as String,
      species: json['species'] as String,
      speciesEn: json['species_en'] as String? ?? json['species'] as String,
      gender: json['gender'] as String,
      genderEn: json['gender_en'] as String? ?? json['gender'] as String,
      firstArc: json['first_arc'] as String,
      firstArcEn: json['first_arc_en'] as String? ?? json['first_arc'] as String,
      arcOrder: json['arc_order'] as int,
      imageUrl: json['image_url'] as String?,
    );
  }

  bool get _isThai => Get.locale?.languageCode == 'th';

  /// Name in the current app locale.
  String get displayName => _isThai ? name : nameEn;
  String get displayFamily => _isThai ? family : familyEn;
  String get displayFlameAttribute => _isThai ? flameAttribute : flameAttributeEn;
  String get displayRole => _isThai ? role : roleEn;
  String get displayBoxAnimal => _isThai ? boxAnimal : boxAnimalEn;
  String get displayWeaponType => _isThai ? weaponType : weaponTypeEn;
  String get displaySpecies => _isThai ? species : speciesEn;
  String get displayGender => _isThai ? gender : genderEn;
  String get displayFirstArc => _isThai ? firstArc : firstArcEn;

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    return name.toLowerCase().contains(q) || nameEn.toLowerCase().contains(q);
  }
}

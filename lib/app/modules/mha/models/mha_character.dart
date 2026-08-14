import 'package:get/get.dart';

class MhaCharacter {
  final String name;
  final String nameEn;
  final String affiliation;
  final String affiliationEn;
  final String quirkType;
  final String quirkTypeEn;
  final String quirkName;
  final String quirkNameEn;
  final String role;
  final String roleEn;
  final String weaponType;
  final String weaponTypeEn;
  final String gender;
  final String genderEn;
  final String heroName;
  final String heroNameEn;
  final String saga;
  final String sagaEn;
  final int sagaOrder;
  final String? imageUrl;

  const MhaCharacter({
    required this.name,
    required this.nameEn,
    required this.affiliation,
    required this.affiliationEn,
    required this.quirkType,
    required this.quirkTypeEn,
    required this.quirkName,
    required this.quirkNameEn,
    required this.role,
    required this.roleEn,
    required this.weaponType,
    required this.weaponTypeEn,
    required this.gender,
    required this.genderEn,
    required this.heroName,
    required this.heroNameEn,
    required this.saga,
    required this.sagaEn,
    required this.sagaOrder,
    this.imageUrl,
  });

  factory MhaCharacter.fromJson(Map<String, dynamic> json) {
    return MhaCharacter(
      name: json['name'] as String,
      nameEn: json['name_en'] as String? ?? json['name'] as String,
      affiliation: json['affiliation'] as String,
      affiliationEn:
          json['affiliation_en'] as String? ?? json['affiliation'] as String,
      quirkType: json['quirk_type'] as String,
      quirkTypeEn: json['quirk_type_en'] as String? ?? json['quirk_type'] as String,
      quirkName: json['quirk_name'] as String,
      quirkNameEn: json['quirk_name_en'] as String? ?? json['quirk_name'] as String,
      role: json['role'] as String,
      roleEn: json['role_en'] as String? ?? json['role'] as String,
      weaponType: json['weapon_type'] as String,
      weaponTypeEn:
          json['weapon_type_en'] as String? ?? json['weapon_type'] as String,
      gender: json['gender'] as String,
      genderEn: json['gender_en'] as String? ?? json['gender'] as String,
      heroName: json['hero_name'] as String,
      heroNameEn: json['hero_name_en'] as String? ?? json['hero_name'] as String,
      saga: json['saga'] as String,
      sagaEn: json['saga_en'] as String? ?? json['saga'] as String,
      sagaOrder: json['saga_order'] as int,
      imageUrl: json['image_url'] as String?,
    );
  }

  bool get _isThai => Get.locale?.languageCode == 'th';

  /// Name in the current app locale.
  String get displayName => _isThai ? name : nameEn;
  String get displayAffiliation => _isThai ? affiliation : affiliationEn;
  String get displayQuirkType => _isThai ? quirkType : quirkTypeEn;
  String get displayQuirkName => _isThai ? quirkName : quirkNameEn;
  String get displayRole => _isThai ? role : roleEn;
  String get displayWeaponType => _isThai ? weaponType : weaponTypeEn;
  String get displayGender => _isThai ? gender : genderEn;
  String get displayHeroName => _isThai ? heroName : heroNameEn;
  String get displaySaga => _isThai ? saga : sagaEn;

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    return name.toLowerCase().contains(q) || nameEn.toLowerCase().contains(q);
  }
}

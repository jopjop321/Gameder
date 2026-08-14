import 'package:get/get.dart';

class HxhCharacter {
  final String name;
  final String nameEn;
  final String affiliation;
  final String affiliationEn;
  final String nenType;
  final String nenTypeEn;
  final String hunterLicense;
  final String hunterLicenseEn;
  final String role;
  final String roleEn;
  final String weaponType;
  final String weaponTypeEn;
  final String gender;
  final String genderEn;
  final String hatsuName;
  final String hatsuNameEn;
  final String saga;
  final String sagaEn;
  final int sagaOrder;
  final String? imageUrl;

  const HxhCharacter({
    required this.name,
    required this.nameEn,
    required this.affiliation,
    required this.affiliationEn,
    required this.nenType,
    required this.nenTypeEn,
    required this.hunterLicense,
    required this.hunterLicenseEn,
    required this.role,
    required this.roleEn,
    required this.weaponType,
    required this.weaponTypeEn,
    required this.gender,
    required this.genderEn,
    required this.hatsuName,
    required this.hatsuNameEn,
    required this.saga,
    required this.sagaEn,
    required this.sagaOrder,
    this.imageUrl,
  });

  factory HxhCharacter.fromJson(Map<String, dynamic> json) {
    return HxhCharacter(
      name: json['name'] as String,
      nameEn: json['name_en'] as String? ?? json['name'] as String,
      affiliation: json['affiliation'] as String,
      affiliationEn:
          json['affiliation_en'] as String? ?? json['affiliation'] as String,
      nenType: json['nen_type'] as String,
      nenTypeEn: json['nen_type_en'] as String? ?? json['nen_type'] as String,
      hunterLicense: json['hunter_license'] as String,
      hunterLicenseEn:
          json['hunter_license_en'] as String? ??
              json['hunter_license'] as String,
      role: json['role'] as String,
      roleEn: json['role_en'] as String? ?? json['role'] as String,
      weaponType: json['weapon_type'] as String,
      weaponTypeEn:
          json['weapon_type_en'] as String? ?? json['weapon_type'] as String,
      gender: json['gender'] as String,
      genderEn: json['gender_en'] as String? ?? json['gender'] as String,
      hatsuName: json['hatsu_name'] as String,
      hatsuNameEn:
          json['hatsu_name_en'] as String? ?? json['hatsu_name'] as String,
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
  String get displayNenType => _isThai ? nenType : nenTypeEn;
  String get displayHunterLicense => _isThai ? hunterLicense : hunterLicenseEn;
  String get displayRole => _isThai ? role : roleEn;
  String get displayWeaponType => _isThai ? weaponType : weaponTypeEn;
  String get displayGender => _isThai ? gender : genderEn;
  String get displayHatsuName => _isThai ? hatsuName : hatsuNameEn;
  String get displaySaga => _isThai ? saga : sagaEn;

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    return name.toLowerCase().contains(q) || nameEn.toLowerCase().contains(q);
  }
}

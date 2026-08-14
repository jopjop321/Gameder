import 'package:get/get.dart';

class BleachCharacter {
  final String name;
  final String nameEn;
  final String affiliation;
  final String affiliationEn;
  final String race;
  final String raceEn;
  final String zanpakutoName;
  final String zanpakutoNameEn;
  final String rank;
  final String rankEn;
  final String weaponType;
  final String weaponTypeEn;
  final String gender;
  final String genderEn;
  final String shikaiBankai;
  final String shikaiBankaiEn;
  final String saga;
  final String sagaEn;
  final int sagaOrder;
  final String? imageUrl;

  const BleachCharacter({
    required this.name,
    required this.nameEn,
    required this.affiliation,
    required this.affiliationEn,
    required this.race,
    required this.raceEn,
    required this.zanpakutoName,
    required this.zanpakutoNameEn,
    required this.rank,
    required this.rankEn,
    required this.weaponType,
    required this.weaponTypeEn,
    required this.gender,
    required this.genderEn,
    required this.shikaiBankai,
    required this.shikaiBankaiEn,
    required this.saga,
    required this.sagaEn,
    required this.sagaOrder,
    this.imageUrl,
  });

  factory BleachCharacter.fromJson(Map<String, dynamic> json) {
    return BleachCharacter(
      name: json['name'] as String,
      nameEn: json['name_en'] as String? ?? json['name'] as String,
      affiliation: json['affiliation'] as String,
      affiliationEn:
          json['affiliation_en'] as String? ?? json['affiliation'] as String,
      race: json['race'] as String,
      raceEn: json['race_en'] as String? ?? json['race'] as String,
      zanpakutoName: json['zanpakuto_name'] as String,
      zanpakutoNameEn:
          json['zanpakuto_name_en'] as String? ??
              json['zanpakuto_name'] as String,
      rank: json['rank'] as String,
      rankEn: json['rank_en'] as String? ?? json['rank'] as String,
      weaponType: json['weapon_type'] as String,
      weaponTypeEn:
          json['weapon_type_en'] as String? ?? json['weapon_type'] as String,
      gender: json['gender'] as String,
      genderEn: json['gender_en'] as String? ?? json['gender'] as String,
      shikaiBankai: json['shikai_bankai'] as String,
      shikaiBankaiEn:
          json['shikai_bankai_en'] as String? ??
              json['shikai_bankai'] as String,
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
  String get displayRace => _isThai ? race : raceEn;
  String get displayZanpakutoName => _isThai ? zanpakutoName : zanpakutoNameEn;
  String get displayRank => _isThai ? rank : rankEn;
  String get displayWeaponType => _isThai ? weaponType : weaponTypeEn;
  String get displayGender => _isThai ? gender : genderEn;
  String get displayShikaiBankai => _isThai ? shikaiBankai : shikaiBankaiEn;
  String get displaySaga => _isThai ? saga : sagaEn;

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    return name.toLowerCase().contains(q) || nameEn.toLowerCase().contains(q);
  }
}

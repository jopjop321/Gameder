import 'package:get/get.dart';

class AotCharacter {
  final String name;
  final String nameEn;
  final String affiliation;
  final String affiliationEn;
  final String titanType;
  final String titanTypeEn;
  final String rank;
  final String rankEn;
  final String weaponType;
  final String weaponTypeEn;
  final String species;
  final String speciesEn;
  final String gender;
  final String genderEn;
  final String origin;
  final String originEn;
  final String saga;
  final String sagaEn;
  final int sagaOrder;
  final String? imageUrl;

  const AotCharacter({
    required this.name,
    required this.nameEn,
    required this.affiliation,
    required this.affiliationEn,
    required this.titanType,
    required this.titanTypeEn,
    required this.rank,
    required this.rankEn,
    required this.weaponType,
    required this.weaponTypeEn,
    required this.species,
    required this.speciesEn,
    required this.gender,
    required this.genderEn,
    required this.origin,
    required this.originEn,
    required this.saga,
    required this.sagaEn,
    required this.sagaOrder,
    this.imageUrl,
  });

  factory AotCharacter.fromJson(Map<String, dynamic> json) {
    return AotCharacter(
      name: json['name'] as String,
      nameEn: json['name_en'] as String? ?? json['name'] as String,
      affiliation: json['affiliation'] as String,
      affiliationEn:
          json['affiliation_en'] as String? ?? json['affiliation'] as String,
      titanType: json['titan_type'] as String,
      titanTypeEn:
          json['titan_type_en'] as String? ?? json['titan_type'] as String,
      rank: json['rank'] as String,
      rankEn: json['rank_en'] as String? ?? json['rank'] as String,
      weaponType: json['weapon_type'] as String,
      weaponTypeEn:
          json['weapon_type_en'] as String? ?? json['weapon_type'] as String,
      species: json['species'] as String,
      speciesEn: json['species_en'] as String? ?? json['species'] as String,
      gender: json['gender'] as String,
      genderEn: json['gender_en'] as String? ?? json['gender'] as String,
      origin: json['origin'] as String,
      originEn: json['origin_en'] as String? ?? json['origin'] as String,
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
  String get displayTitanType => _isThai ? titanType : titanTypeEn;
  String get displayRank => _isThai ? rank : rankEn;
  String get displayWeaponType => _isThai ? weaponType : weaponTypeEn;
  String get displaySpecies => _isThai ? species : speciesEn;
  String get displayGender => _isThai ? gender : genderEn;
  String get displayOrigin => _isThai ? origin : originEn;
  String get displaySaga => _isThai ? saga : sagaEn;

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    return name.toLowerCase().contains(q) || nameEn.toLowerCase().contains(q);
  }
}

import 'package:get/get.dart';

class OnePieceCharacter {
  final String name;
  final String nameEn;
  final String crew;
  final String crewEn;
  final String devilFruitType;
  final String devilFruitTypeEn;
  final String devilFruitName;
  final String devilFruitNameEn;
  final String role;
  final String roleEn;
  final String weaponType;
  final String weaponTypeEn;
  final String species;
  final String speciesEn;
  final String gender;
  final String genderEn;
  final int? bounty;
  final String saga;
  final String sagaEn;
  final int sagaOrder;
  final String? imageUrl;

  const OnePieceCharacter({
    required this.name,
    required this.nameEn,
    required this.crew,
    required this.crewEn,
    required this.devilFruitType,
    required this.devilFruitTypeEn,
    required this.devilFruitName,
    required this.devilFruitNameEn,
    required this.role,
    required this.roleEn,
    required this.weaponType,
    required this.weaponTypeEn,
    required this.species,
    required this.speciesEn,
    required this.gender,
    required this.genderEn,
    this.bounty,
    required this.saga,
    required this.sagaEn,
    required this.sagaOrder,
    this.imageUrl,
  });

  factory OnePieceCharacter.fromJson(Map<String, dynamic> json) {
    return OnePieceCharacter(
      name: json['name'] as String,
      nameEn: json['name_en'] as String? ?? json['name'] as String,
      crew: json['crew'] as String,
      crewEn: json['crew_en'] as String? ?? json['crew'] as String,
      devilFruitType: json['devil_fruit_type'] as String,
      devilFruitTypeEn:
          json['devil_fruit_type_en'] as String? ??
              json['devil_fruit_type'] as String,
      devilFruitName: json['devil_fruit_name'] as String,
      devilFruitNameEn:
          json['devil_fruit_name_en'] as String? ??
              json['devil_fruit_name'] as String,
      role: json['role'] as String,
      roleEn: json['role_en'] as String? ?? json['role'] as String,
      weaponType: json['weapon_type'] as String,
      weaponTypeEn:
          json['weapon_type_en'] as String? ?? json['weapon_type'] as String,
      species: json['species'] as String,
      speciesEn: json['species_en'] as String? ?? json['species'] as String,
      gender: json['gender'] as String,
      genderEn: json['gender_en'] as String? ?? json['gender'] as String,
      bounty: json['bounty'] as int?,
      saga: json['saga'] as String,
      sagaEn: json['saga_en'] as String? ?? json['saga'] as String,
      sagaOrder: json['saga_order'] as int,
      imageUrl: json['image_url'] as String?,
    );
  }

  bool get _isThai => Get.locale?.languageCode == 'th';

  /// Name in the current app locale.
  String get displayName => _isThai ? name : nameEn;
  String get displayCrew => _isThai ? crew : crewEn;
  String get displayDevilFruitType => _isThai ? devilFruitType : devilFruitTypeEn;
  String get displayDevilFruitName => _isThai ? devilFruitName : devilFruitNameEn;
  String get displayRole => _isThai ? role : roleEn;
  String get displayWeaponType => _isThai ? weaponType : weaponTypeEn;
  String get displaySpecies => _isThai ? species : speciesEn;
  String get displayGender => _isThai ? gender : genderEn;
  String get displaySaga => _isThai ? saga : sagaEn;

  String get displayBounty {
    final b = bounty;
    if (b == null) return _isThai ? 'ไม่ทราบ' : 'Unknown';
    return '฿${b.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
        )}';
  }

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    return name.toLowerCase().contains(q) || nameEn.toLowerCase().contains(q);
  }
}

import 'package:get/get.dart';

class BlackcloverCharacter {
  final String name;
  final String nameEn;
  final String squad;
  final String squadEn;
  final String magicType;
  final String magicTypeEn;
  final String grimoireClover;
  final String grimoireCloverEn;
  final String role;
  final String roleEn;
  final String weaponType;
  final String weaponTypeEn;
  final String gender;
  final String genderEn;
  final String kingdom;
  final String kingdomEn;
  final String saga;
  final String sagaEn;
  final int sagaOrder;
  final String? imageUrl;

  const BlackcloverCharacter({
    required this.name,
    required this.nameEn,
    required this.squad,
    required this.squadEn,
    required this.magicType,
    required this.magicTypeEn,
    required this.grimoireClover,
    required this.grimoireCloverEn,
    required this.role,
    required this.roleEn,
    required this.weaponType,
    required this.weaponTypeEn,
    required this.gender,
    required this.genderEn,
    required this.kingdom,
    required this.kingdomEn,
    required this.saga,
    required this.sagaEn,
    required this.sagaOrder,
    this.imageUrl,
  });

  factory BlackcloverCharacter.fromJson(Map<String, dynamic> json) {
    return BlackcloverCharacter(
      name: json['name'] as String,
      nameEn: json['name_en'] as String? ?? json['name'] as String,
      squad: json['squad'] as String,
      squadEn: json['squad_en'] as String? ?? json['squad'] as String,
      magicType: json['magic_type'] as String,
      magicTypeEn:
          json['magic_type_en'] as String? ?? json['magic_type'] as String,
      grimoireClover: json['grimoire_clover'] as String,
      grimoireCloverEn:
          json['grimoire_clover_en'] as String? ??
              json['grimoire_clover'] as String,
      role: json['role'] as String,
      roleEn: json['role_en'] as String? ?? json['role'] as String,
      weaponType: json['weapon_type'] as String,
      weaponTypeEn:
          json['weapon_type_en'] as String? ?? json['weapon_type'] as String,
      gender: json['gender'] as String,
      genderEn: json['gender_en'] as String? ?? json['gender'] as String,
      kingdom: json['kingdom'] as String,
      kingdomEn: json['kingdom_en'] as String? ?? json['kingdom'] as String,
      saga: json['saga'] as String,
      sagaEn: json['saga_en'] as String? ?? json['saga'] as String,
      sagaOrder: json['saga_order'] as int,
      imageUrl: json['image_url'] as String?,
    );
  }

  bool get _isThai => Get.locale?.languageCode == 'th';

  /// Name in the current app locale.
  String get displayName => _isThai ? name : nameEn;
  String get displaySquad => _isThai ? squad : squadEn;
  String get displayMagicType => _isThai ? magicType : magicTypeEn;
  String get displayGrimoireClover =>
      _isThai ? grimoireClover : grimoireCloverEn;
  String get displayRole => _isThai ? role : roleEn;
  String get displayWeaponType => _isThai ? weaponType : weaponTypeEn;
  String get displayGender => _isThai ? gender : genderEn;
  String get displayKingdom => _isThai ? kingdom : kingdomEn;
  String get displaySaga => _isThai ? saga : sagaEn;

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    return name.toLowerCase().contains(q) || nameEn.toLowerCase().contains(q);
  }
}

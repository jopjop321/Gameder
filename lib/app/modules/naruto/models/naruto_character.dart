import 'package:get/get.dart';

class NarutoCharacter {
  final String name;
  final String nameEn;
  final String village;
  final String villageEn;
  final String clan;
  final String clanEn;
  final String chakraNature;
  final String chakraNatureEn;
  final String rank;
  final String rankEn;
  final String team;
  final String teamEn;
  final String weaponType;
  final String weaponTypeEn;
  final String gender;
  final String genderEn;
  final String bijuu;
  final String bijuuEn;
  final String saga;
  final String sagaEn;
  final int sagaOrder;
  final String? imageUrl;

  const NarutoCharacter({
    required this.name,
    required this.nameEn,
    required this.village,
    required this.villageEn,
    required this.clan,
    required this.clanEn,
    required this.chakraNature,
    required this.chakraNatureEn,
    required this.rank,
    required this.rankEn,
    required this.team,
    required this.teamEn,
    required this.weaponType,
    required this.weaponTypeEn,
    required this.gender,
    required this.genderEn,
    required this.bijuu,
    required this.bijuuEn,
    required this.saga,
    required this.sagaEn,
    required this.sagaOrder,
    this.imageUrl,
  });

  factory NarutoCharacter.fromJson(Map<String, dynamic> json) {
    return NarutoCharacter(
      name: json['name'] as String,
      nameEn: json['name_en'] as String? ?? json['name'] as String,
      village: json['village'] as String,
      villageEn: json['village_en'] as String? ?? json['village'] as String,
      clan: json['clan'] as String,
      clanEn: json['clan_en'] as String? ?? json['clan'] as String,
      chakraNature: json['chakra_nature'] as String,
      chakraNatureEn:
          json['chakra_nature_en'] as String? ??
              json['chakra_nature'] as String,
      rank: json['rank'] as String,
      rankEn: json['rank_en'] as String? ?? json['rank'] as String,
      team: json['team'] as String,
      teamEn: json['team_en'] as String? ?? json['team'] as String,
      weaponType: json['weapon_type'] as String,
      weaponTypeEn:
          json['weapon_type_en'] as String? ?? json['weapon_type'] as String,
      gender: json['gender'] as String,
      genderEn: json['gender_en'] as String? ?? json['gender'] as String,
      bijuu: json['bijuu'] as String,
      bijuuEn: json['bijuu_en'] as String? ?? json['bijuu'] as String,
      saga: json['saga'] as String,
      sagaEn: json['saga_en'] as String? ?? json['saga'] as String,
      sagaOrder: json['saga_order'] as int,
      imageUrl: json['image_url'] as String?,
    );
  }

  bool get _isThai => Get.locale?.languageCode == 'th';

  /// Name in the current app locale.
  String get displayName => _isThai ? name : nameEn;
  String get displayVillage => _isThai ? village : villageEn;
  String get displayClan => _isThai ? clan : clanEn;
  String get displayChakraNature => _isThai ? chakraNature : chakraNatureEn;
  String get displayRank => _isThai ? rank : rankEn;
  String get displayTeam => _isThai ? team : teamEn;
  String get displayWeaponType => _isThai ? weaponType : weaponTypeEn;
  String get displayGender => _isThai ? gender : genderEn;
  String get displayBijuu => _isThai ? bijuu : bijuuEn;
  String get displaySaga => _isThai ? saga : sagaEn;

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    return name.toLowerCase().contains(q) || nameEn.toLowerCase().contains(q);
  }
}

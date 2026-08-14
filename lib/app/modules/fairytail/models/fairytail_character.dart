import 'package:get/get.dart';

class FairytailCharacter {
  final String name;
  final String nameEn;
  final String guild;
  final String guildEn;
  final String magicType;
  final String magicTypeEn;
  final String team;
  final String teamEn;
  final String guildRank;
  final String guildRankEn;
  final String weaponType;
  final String weaponTypeEn;
  final String gender;
  final String genderEn;
  final String guildMarkColor;
  final String guildMarkColorEn;
  final String saga;
  final String sagaEn;
  final int sagaOrder;
  final String? imageUrl;

  const FairytailCharacter({
    required this.name,
    required this.nameEn,
    required this.guild,
    required this.guildEn,
    required this.magicType,
    required this.magicTypeEn,
    required this.team,
    required this.teamEn,
    required this.guildRank,
    required this.guildRankEn,
    required this.weaponType,
    required this.weaponTypeEn,
    required this.gender,
    required this.genderEn,
    required this.guildMarkColor,
    required this.guildMarkColorEn,
    required this.saga,
    required this.sagaEn,
    required this.sagaOrder,
    this.imageUrl,
  });

  factory FairytailCharacter.fromJson(Map<String, dynamic> json) {
    return FairytailCharacter(
      name: json['name'] as String,
      nameEn: json['name_en'] as String? ?? json['name'] as String,
      guild: json['guild'] as String,
      guildEn: json['guild_en'] as String? ?? json['guild'] as String,
      magicType: json['magic_type'] as String,
      magicTypeEn:
          json['magic_type_en'] as String? ?? json['magic_type'] as String,
      team: json['team'] as String,
      teamEn: json['team_en'] as String? ?? json['team'] as String,
      guildRank: json['guild_rank'] as String,
      guildRankEn:
          json['guild_rank_en'] as String? ?? json['guild_rank'] as String,
      weaponType: json['weapon_type'] as String,
      weaponTypeEn:
          json['weapon_type_en'] as String? ?? json['weapon_type'] as String,
      gender: json['gender'] as String,
      genderEn: json['gender_en'] as String? ?? json['gender'] as String,
      guildMarkColor: json['guild_mark_color'] as String,
      guildMarkColorEn: json['guild_mark_color_en'] as String? ??
          json['guild_mark_color'] as String,
      saga: json['saga'] as String,
      sagaEn: json['saga_en'] as String? ?? json['saga'] as String,
      sagaOrder: json['saga_order'] as int,
      imageUrl: json['image_url'] as String?,
    );
  }

  bool get _isThai => Get.locale?.languageCode == 'th';

  /// Name in the current app locale.
  String get displayName => _isThai ? name : nameEn;
  String get displayGuild => _isThai ? guild : guildEn;
  String get displayMagicType => _isThai ? magicType : magicTypeEn;
  String get displayTeam => _isThai ? team : teamEn;
  String get displayGuildRank => _isThai ? guildRank : guildRankEn;
  String get displayWeaponType => _isThai ? weaponType : weaponTypeEn;
  String get displayGender => _isThai ? gender : genderEn;
  String get displayGuildMarkColor =>
      _isThai ? guildMarkColor : guildMarkColorEn;
  String get displaySaga => _isThai ? saga : sagaEn;

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    return name.toLowerCase().contains(q) || nameEn.toLowerCase().contains(q);
  }
}

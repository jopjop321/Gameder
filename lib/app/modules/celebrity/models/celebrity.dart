import 'package:get/get.dart';

enum CelebrityCollection {
  youtuber,
  globalYoutuber,
  actor,
  singer,
  athlete,
  kpopIdol,
  ySeriesActor,
  koreanActor,
}

class Celebrity {
  final CelebrityCollection collection;
  final String name;
  final String nameEn;
  final String? realName;
  final String? realNameEn;
  final String subCategory;
  final String subCategoryEn;
  final String gender;
  final String genderEn;
  final int debutYear;
  final String region;
  final String regionEn;
  final String agency;
  final String agencyEn;
  final List<String> platforms;

  /// YouTuber collection only: 'เดี่ยว', 'คู่', 'กลุ่ม', 'ครอบครัว'.
  final String? channelType;
  final String? channelTypeEn;

  /// YouTuber collection only: '<100K', '100K-500K', '500K-1M', '1M-5M', '5M-10M', '10M+'.
  final String? subscriberTier;

  const Celebrity({
    required this.collection,
    required this.name,
    required this.nameEn,
    this.realName,
    this.realNameEn,
    required this.subCategory,
    required this.subCategoryEn,
    required this.gender,
    required this.genderEn,
    required this.debutYear,
    required this.region,
    required this.regionEn,
    required this.agency,
    required this.agencyEn,
    required this.platforms,
    this.channelType,
    this.channelTypeEn,
    this.subscriberTier,
  });

  factory Celebrity.fromJson(Map<String, dynamic> json) {
    return Celebrity(
      collection: CelebrityCollection.values.byName(
        json['collection'] as String,
      ),
      name: json['name'] as String,
      nameEn: json['name_en'] as String? ?? json['name'] as String,
      realName: json['real_name'] as String?,
      realNameEn: json['real_name_en'] as String?,
      subCategory: json['sub_category'] as String,
      subCategoryEn:
          json['sub_category_en'] as String? ?? json['sub_category'] as String,
      gender: json['gender'] as String,
      genderEn: json['gender_en'] as String? ?? json['gender'] as String,
      debutYear: json['debut_year'] as int,
      region: json['region'] as String,
      regionEn: json['region_en'] as String? ?? json['region'] as String,
      agency: json['agency'] as String,
      agencyEn: json['agency_en'] as String? ?? json['agency'] as String,
      platforms: (json['platforms'] as List<dynamic>? ?? []).cast<String>(),
      channelType: json['channel_type'] as String?,
      channelTypeEn: json['channel_type_en'] as String?,
      subscriberTier: json['subscriber_tier'] as String?,
    );
  }

  bool get _isThai => Get.locale?.languageCode == 'th';

  String get displayName => _isThai ? name : nameEn;
  String? get displayRealName => _isThai ? realName : (realNameEn ?? realName);
  String get displaySubCategory => _isThai ? subCategory : subCategoryEn;
  String get displayGender => _isThai ? gender : genderEn;
  String get displayRegion => _isThai ? region : regionEn;
  String get displayAgency => _isThai ? agency : agencyEn;
  String? get displayChannelType =>
      _isThai ? channelType : (channelTypeEn ?? channelType);

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    return name.toLowerCase().contains(q) || nameEn.toLowerCase().contains(q);
  }
}

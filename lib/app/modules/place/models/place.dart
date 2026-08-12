import 'package:get/get.dart';

enum PlaceCollection { thailand, world }

class Place {
  final PlaceCollection collection;
  final String name;
  final String nameEn;
  final String country;
  final String countryEn;
  final String continent;
  final String continentEn;
  final String? region;
  final String? regionEn;
  final String placeType;
  final String placeTypeEn;
  final String mainFeature;
  final String mainFeatureEn;
  final String featureGroup;
  final String featureGroupEn;
  final String activity;
  final String activityEn;
  final List<String> highlights;
  final List<String> highlightsEn;
  final int costLevel;

  const Place({
    required this.collection,
    required this.name,
    required this.nameEn,
    required this.country,
    required this.countryEn,
    required this.continent,
    required this.continentEn,
    this.region,
    this.regionEn,
    required this.placeType,
    required this.placeTypeEn,
    required this.mainFeature,
    required this.mainFeatureEn,
    required this.featureGroup,
    required this.featureGroupEn,
    required this.activity,
    required this.activityEn,
    required this.highlights,
    required this.highlightsEn,
    required this.costLevel,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      collection: PlaceCollection.values.byName(json['collection'] as String),
      name: json['name'] as String,
      nameEn: json['name_en'] as String? ?? json['name'] as String,
      country: json['country'] as String,
      countryEn: json['country_en'] as String? ?? json['country'] as String,
      continent: json['continent'] as String,
      continentEn:
          json['continent_en'] as String? ?? json['continent'] as String,
      region: json['region'] as String?,
      regionEn: json['region_en'] as String? ?? json['region'] as String?,
      placeType: json['place_type'] as String,
      placeTypeEn:
          json['place_type_en'] as String? ?? json['place_type'] as String,
      mainFeature: json['main_feature'] as String,
      mainFeatureEn:
          json['main_feature_en'] as String? ?? json['main_feature'] as String,
      featureGroup: json['feature_group'] as String,
      featureGroupEn: json['feature_group_en'] as String? ??
          json['feature_group'] as String,
      activity: json['activity'] as String,
      activityEn: json['activity_en'] as String? ?? json['activity'] as String,
      highlights: (json['highlights'] as List<dynamic>).cast<String>(),
      highlightsEn: (json['highlights_en'] as List<dynamic>?)?.cast<String>() ??
          (json['highlights'] as List<dynamic>).cast<String>(),
      costLevel: json['cost_level'] as int,
    );
  }

  bool get _isThai => Get.locale?.languageCode == 'th';

  String get displayName => _isThai ? name : nameEn;
  String get displayCountry => _isThai ? country : countryEn;
  String get displayContinent => _isThai ? continent : continentEn;
  String? get displayRegion => _isThai ? region : (regionEn ?? region);
  String get displayPlaceType => _isThai ? placeType : placeTypeEn;
  String get displayMainFeature => _isThai ? mainFeature : mainFeatureEn;
  String get displayActivity => _isThai ? activity : activityEn;
  List<String> get displayHighlights => _isThai ? highlights : highlightsEn;

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    return name.toLowerCase().contains(q) || nameEn.toLowerCase().contains(q);
  }
}

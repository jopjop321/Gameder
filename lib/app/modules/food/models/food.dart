import 'package:get/get.dart';

enum FoodCollection { thai, japanese, chinese, european, world }

class Food {
  final FoodCollection collection;
  final String name;
  final String nameEn;
  final String country;
  final String countryEn;
  final String continent;
  final String continentEn;
  final String? region;
  final String? regionEn;
  final String dishType;
  final String dishTypeEn;
  final String mainIngredient;
  final String mainIngredientEn;
  final String ingredientGroup;
  final String ingredientGroupEn;
  final String cookingMethod;
  final String cookingMethodEn;
  final List<String> flavors;
  final List<String> flavorsEn;
  final int spiceLevel;
  final String servingTemperature;
  final String servingTemperatureEn;

  const Food({
    required this.collection,
    required this.name,
    required this.nameEn,
    required this.country,
    required this.countryEn,
    required this.continent,
    required this.continentEn,
    this.region,
    this.regionEn,
    required this.dishType,
    required this.dishTypeEn,
    required this.mainIngredient,
    required this.mainIngredientEn,
    required this.ingredientGroup,
    required this.ingredientGroupEn,
    required this.cookingMethod,
    required this.cookingMethodEn,
    required this.flavors,
    required this.flavorsEn,
    required this.spiceLevel,
    required this.servingTemperature,
    required this.servingTemperatureEn,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      collection: FoodCollection.values.byName(json['collection'] as String),
      name: json['name'] as String,
      nameEn: json['name_en'] as String? ?? json['name'] as String,
      country: json['country'] as String,
      countryEn: json['country_en'] as String? ?? json['country'] as String,
      continent: json['continent'] as String,
      continentEn:
          json['continent_en'] as String? ?? json['continent'] as String,
      region: json['region'] as String?,
      regionEn: json['region_en'] as String? ?? json['region'] as String?,
      dishType: json['dish_type'] as String,
      dishTypeEn: json['dish_type_en'] as String? ?? json['dish_type'] as String,
      mainIngredient: json['main_ingredient'] as String,
      mainIngredientEn: json['main_ingredient_en'] as String? ??
          json['main_ingredient'] as String,
      ingredientGroup: json['ingredient_group'] as String,
      ingredientGroupEn: json['ingredient_group_en'] as String? ??
          json['ingredient_group'] as String,
      cookingMethod: json['cooking_method'] as String,
      cookingMethodEn: json['cooking_method_en'] as String? ??
          json['cooking_method'] as String,
      flavors: (json['flavors'] as List<dynamic>).cast<String>(),
      flavorsEn: (json['flavors_en'] as List<dynamic>?)?.cast<String>() ??
          (json['flavors'] as List<dynamic>).cast<String>(),
      spiceLevel: json['spice_level'] as int,
      servingTemperature: json['serving_temperature'] as String,
      servingTemperatureEn: json['serving_temperature_en'] as String? ??
          json['serving_temperature'] as String,
    );
  }

  bool get _isThai => Get.locale?.languageCode == 'th';

  String get displayName => _isThai ? name : nameEn;
  String get displayCountry => _isThai ? country : countryEn;
  String get displayContinent => _isThai ? continent : continentEn;
  String? get displayRegion => _isThai ? region : (regionEn ?? region);
  String get displayDishType => _isThai ? dishType : dishTypeEn;
  String get displayMainIngredient =>
      _isThai ? mainIngredient : mainIngredientEn;
  String get displayCookingMethod => _isThai ? cookingMethod : cookingMethodEn;
  List<String> get displayFlavors => _isThai ? flavors : flavorsEn;
  String get displayServingTemperature =>
      _isThai ? servingTemperature : servingTemperatureEn;

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    return name.toLowerCase().contains(q) || nameEn.toLowerCase().contains(q);
  }
}

enum FoodCollection { thai, japanese, chinese, european, world }

class Food {
  final FoodCollection collection;
  final String name;
  final String country;
  final String continent;
  final String? region;
  final String dishType;
  final String mainIngredient;
  final String ingredientGroup;
  final String cookingMethod;
  final List<String> flavors;
  final int spiceLevel;
  final String servingTemperature;

  const Food({
    required this.collection,
    required this.name,
    required this.country,
    required this.continent,
    this.region,
    required this.dishType,
    required this.mainIngredient,
    required this.ingredientGroup,
    required this.cookingMethod,
    required this.flavors,
    required this.spiceLevel,
    required this.servingTemperature,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      collection: FoodCollection.values.byName(json['collection'] as String),
      name: json['name'] as String,
      country: json['country'] as String,
      continent: json['continent'] as String,
      region: json['region'] as String?,
      dishType: json['dish_type'] as String,
      mainIngredient: json['main_ingredient'] as String,
      ingredientGroup: json['ingredient_group'] as String,
      cookingMethod: json['cooking_method'] as String,
      flavors: (json['flavors'] as List<dynamic>).cast<String>(),
      spiceLevel: json['spice_level'] as int,
      servingTemperature: json['serving_temperature'] as String,
    );
  }

  bool matchesQuery(String query) {
    return name.toLowerCase().contains(query.trim().toLowerCase());
  }
}

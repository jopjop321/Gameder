enum CarCollection { all }

class Car {
  final CarCollection collection;
  final String name;
  final String brand;
  final String country;
  final String countryEn;
  final String bodyType;
  final String bodyTypeEn;
  final String fuelType;
  final String fuelTypeEn;
  final String priceSegment;
  final String priceSegmentEn;
  final int launchYear;

  const Car({
    required this.collection,
    required this.name,
    required this.brand,
    required this.country,
    required this.countryEn,
    required this.bodyType,
    required this.bodyTypeEn,
    required this.fuelType,
    required this.fuelTypeEn,
    required this.priceSegment,
    required this.priceSegmentEn,
    required this.launchYear,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      collection: CarCollection.values.byName(json['collection'] as String),
      name: json['name'] as String,
      brand: json['brand'] as String,
      country: json['country'] as String,
      countryEn: json['country_en'] as String,
      bodyType: json['body_type'] as String,
      bodyTypeEn: json['body_type_en'] as String,
      fuelType: json['fuel_type'] as String,
      fuelTypeEn: json['fuel_type_en'] as String,
      priceSegment: json['price_segment'] as String,
      priceSegmentEn: json['price_segment_en'] as String,
      launchYear: json['launch_year'] as int,
    );
  }

  bool matchesQuery(String query) {
    return name.toLowerCase().contains(query.trim().toLowerCase());
  }
}

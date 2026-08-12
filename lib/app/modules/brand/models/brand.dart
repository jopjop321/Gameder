enum BrandCollection { all }

class Brand {
  final BrandCollection collection;
  final String name;
  final String industry;
  final String industryEn;
  final String industryGroup;
  final String industryGroupEn;
  final String country;
  final String countryEn;
  final String headquartersCity;
  final String headquartersCityEn;
  final String ownershipType;
  final String ownershipTypeEn;
  final String? parentCompany;
  final int foundedYear;

  const Brand({
    required this.collection,
    required this.name,
    required this.industry,
    required this.industryEn,
    required this.industryGroup,
    required this.industryGroupEn,
    required this.country,
    required this.countryEn,
    required this.headquartersCity,
    required this.headquartersCityEn,
    required this.ownershipType,
    required this.ownershipTypeEn,
    required this.parentCompany,
    required this.foundedYear,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      collection: BrandCollection.values.byName(json['collection'] as String),
      name: json['name'] as String,
      industry: json['industry'] as String,
      industryEn: json['industry_en'] as String,
      industryGroup: json['industry_group'] as String,
      industryGroupEn: json['industry_group_en'] as String,
      country: json['country'] as String,
      countryEn: json['country_en'] as String,
      headquartersCity: json['headquarters_city'] as String,
      headquartersCityEn: json['headquarters_city_en'] as String,
      ownershipType: json['ownership_type'] as String,
      ownershipTypeEn: json['ownership_type_en'] as String,
      parentCompany: json['parent_company'] as String?,
      foundedYear: json['founded_year'] as int,
    );
  }

  bool matchesQuery(String query) {
    return name.toLowerCase().contains(query.trim().toLowerCase());
  }
}

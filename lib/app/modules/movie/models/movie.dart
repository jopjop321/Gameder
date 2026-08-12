enum MovieCollection { all }

class Movie {
  final MovieCollection collection;
  final String name;
  final String nameEn;
  final String director;
  final String genre;
  final String genreEn;
  final String genreGroup;
  final String genreGroupEn;
  final String country;
  final String countryEn;
  final int releaseYear;
  final String studio;
  final String? franchise;
  final String ageRating;

  const Movie({
    required this.collection,
    required this.name,
    required this.nameEn,
    required this.director,
    required this.genre,
    required this.genreEn,
    required this.genreGroup,
    required this.genreGroupEn,
    required this.country,
    required this.countryEn,
    required this.releaseYear,
    required this.studio,
    required this.franchise,
    required this.ageRating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      collection: MovieCollection.values.byName(json['collection'] as String),
      name: json['name'] as String,
      nameEn: json['name_en'] as String,
      director: json['director'] as String,
      genre: json['genre'] as String,
      genreEn: json['genre_en'] as String,
      genreGroup: json['genre_group'] as String,
      genreGroupEn: json['genre_group_en'] as String,
      country: json['country'] as String,
      countryEn: json['country_en'] as String,
      releaseYear: json['release_year'] as int,
      studio: json['studio'] as String,
      franchise: json['franchise'] as String?,
      ageRating: json['age_rating'] as String,
    );
  }

  bool matchesQuery(String query) {
    return name.toLowerCase().contains(query.trim().toLowerCase());
  }
}

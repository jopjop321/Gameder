enum SongCollection { all }

class Song {
  final SongCollection collection;
  final String name;
  final String nameEn;
  final String artist;
  final String artistEn;
  final String genre;
  final String genreEn;
  final String genreGroup;
  final String genreGroupEn;
  final String country;
  final String countryEn;
  final int releaseYear;
  final String label;

  const Song({
    required this.collection,
    required this.name,
    required this.nameEn,
    required this.artist,
    required this.artistEn,
    required this.genre,
    required this.genreEn,
    required this.genreGroup,
    required this.genreGroupEn,
    required this.country,
    required this.countryEn,
    required this.releaseYear,
    required this.label,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      collection: SongCollection.values.byName(json['collection'] as String),
      name: json['name'] as String,
      nameEn: json['name_en'] as String,
      artist: json['artist'] as String,
      artistEn: json['artist_en'] as String,
      genre: json['genre'] as String,
      genreEn: json['genre_en'] as String,
      genreGroup: json['genre_group'] as String,
      genreGroupEn: json['genre_group_en'] as String,
      country: json['country'] as String,
      countryEn: json['country_en'] as String,
      releaseYear: json['release_year'] as int,
      label: json['label'] as String,
    );
  }

  bool matchesQuery(String query) {
    return name.toLowerCase().contains(query.trim().toLowerCase());
  }
}

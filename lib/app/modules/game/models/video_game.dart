enum GameCollection { mobile, pc, nintendo, all }

class VideoGame {
  final GameCollection collection;
  final String name;
  final String developer;
  final String publisher;
  final String country;
  final String genre;
  final String genreGroup;
  final List<String> platforms;
  final int releaseYear;
  final String gameMode;
  final String ageRating;

  const VideoGame({
    required this.collection,
    required this.name,
    required this.developer,
    required this.publisher,
    required this.country,
    required this.genre,
    required this.genreGroup,
    required this.platforms,
    required this.releaseYear,
    required this.gameMode,
    required this.ageRating,
  });

  factory VideoGame.fromJson(Map<String, dynamic> json) {
    return VideoGame(
      collection: GameCollection.values.byName(json['collection'] as String),
      name: json['name'] as String,
      developer: json['developer'] as String,
      publisher: json['publisher'] as String,
      country: json['country'] as String,
      genre: json['genre'] as String,
      genreGroup: json['genre_group'] as String,
      platforms: (json['platforms'] as List<dynamic>).cast<String>(),
      releaseYear: json['release_year'] as int,
      gameMode: json['game_mode'] as String,
      ageRating: json['age_rating'] as String,
    );
  }

  bool matchesQuery(String query) {
    return name.toLowerCase().contains(query.trim().toLowerCase());
  }
}

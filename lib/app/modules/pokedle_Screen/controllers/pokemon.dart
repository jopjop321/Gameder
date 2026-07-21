class Pokemon {
  final int id;
  final String name;
  final String nameTh;
  final String romajiTh;
  final String romajiEn;
  final String type1;
  final String? type2;
  final int evolutionStage;
  final bool fullyEvolved;
  final String color;
  final String habitat;
  final int generation;

  Pokemon({
    required this.id,
    required this.name,
    required this.nameTh,
    required this.romajiTh,
    required this.romajiEn,
    required this.type1,
    this.type2,
    required this.evolutionStage,
    required this.fullyEvolved,
    required this.color,
    required this.habitat,
    required this.generation,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      nameTh: json['name_th'] as String,
      romajiTh: json['romaji_th'] as String,
      romajiEn: json['romaji_en'] as String,
      type1: json['type1'] as String,
      type2: json['type2'] as String?,
      evolutionStage: json['evolution_stage'] as int,
      fullyEvolved: json['fully_evolved'] as bool,
      color: json['color'] as String,
      habitat: json['habitat'] as String,
      generation: json['generation'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_th': nameTh,
      'romaji_th': romajiTh,
      'romaji_en': romajiEn,
      'type1': type1,
      'type2': type2,
      'evolution_stage': evolutionStage,
      'fully_evolved': fullyEvolved,
      'color': color,
      'habitat': habitat,
      'generation': generation,
    };
  }

  /// Official artwork sprite URL from PokeAPI.
  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  /// Convenience list of this Pokemon's types (excludes null type2).
  List<String> get types => [type1, if (type2 != null) type2!];

  /// Whether this Pokemon matches a free-text search query against any of
  /// its four name fields (case-insensitive, partial match).
  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return false;
    return name.toLowerCase().contains(q) ||
        nameTh.toLowerCase().contains(q) ||
        romajiTh.toLowerCase().contains(q) ||
        romajiEn.toLowerCase().contains(q);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Pokemon && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
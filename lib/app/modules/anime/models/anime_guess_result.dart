import 'anime.dart';

enum AnimeMatch { correct, partial, incorrect }

class AnimeMatchCell {
  final String value;
  final AnimeMatch match;

  const AnimeMatchCell(this.value, this.match);
}

class AnimeGuessResult {
  final Anime anime;
  final List<AnimeMatchCell> cells;
  final bool isWin;

  const AnimeGuessResult({
    required this.anime,
    required this.cells,
    required this.isWin,
  });

  factory AnimeGuessResult.evaluate(Anime guess, Anime answer) {
    final yearArrow = guess.releaseYear == answer.releaseYear
        ? ''
        : guess.releaseYear < answer.releaseYear
            ? ' ↑'
            : ' ↓';

    return AnimeGuessResult(
      anime: guess,
      isWin: guess.name == answer.name,
      cells: [
        AnimeMatchCell(
          guess.displayName,
          _exactMatch(guess.name, answer.name),
        ),
        AnimeMatchCell(guess.studio, _exactMatch(guess.studio, answer.studio)),
        AnimeMatchCell(
          guess.demographic,
          _exactMatch(guess.demographic, answer.demographic),
        ),
        AnimeMatchCell(guess.format, _exactMatch(guess.format, answer.format)),
        AnimeMatchCell(
          guess.sourceMaterial,
          _exactMatch(guess.sourceMaterial, answer.sourceMaterial),
        ),
        AnimeMatchCell(guess.genre.join(', '), _genreMatch(guess, answer)),
        AnimeMatchCell(
          '${guess.releaseYear}$yearArrow',
          _exactMatch('${guess.releaseYear}', '${answer.releaseYear}'),
        ),
        AnimeMatchCell(
          guess.protagonistGender,
          _exactMatch(guess.protagonistGender, answer.protagonistGender),
        ),
      ],
    );
  }

  static AnimeMatch _exactMatch(String guess, String answer) =>
      guess == answer ? AnimeMatch.correct : AnimeMatch.incorrect;

  static AnimeMatch _genreMatch(Anime guess, Anime answer) {
    if (_hasSameValues(guess.genre, answer.genre)) return AnimeMatch.correct;
    return guess.genre.toSet().intersection(answer.genre.toSet()).isNotEmpty
        ? AnimeMatch.partial
        : AnimeMatch.incorrect;
  }

  static bool _hasSameValues(List<String> first, List<String> second) {
    return first.length == second.length && first.toSet().containsAll(second);
  }
}

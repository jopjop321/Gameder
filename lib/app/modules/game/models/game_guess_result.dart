import 'video_game.dart';

enum GameMatch { correct, partial, incorrect }

class GameMatchCell {
  final String value;
  final GameMatch match;

  const GameMatchCell(this.value, this.match);
}

class GameGuessResult {
  final VideoGame game;
  final List<GameMatchCell> cells;
  final bool isWin;

  const GameGuessResult({
    required this.game,
    required this.cells,
    required this.isWin,
  });

  factory GameGuessResult.evaluate(VideoGame guess, VideoGame answer) {
    final yearArrow = guess.releaseYear == answer.releaseYear
        ? ''
        : guess.releaseYear < answer.releaseYear
            ? ' ↑'
            : ' ↓';

    return GameGuessResult(
      game: guess,
      isWin: guess.name == answer.name,
      cells: [
        GameMatchCell(guess.name, _exactMatch(guess.name, answer.name)),
        GameMatchCell(
          guess.developer,
          _exactMatch(guess.developer, answer.developer),
        ),
        GameMatchCell(guess.country, _exactMatch(guess.country, answer.country)),
        GameMatchCell(guess.genre, _genreMatch(guess, answer)),
        GameMatchCell(guess.platforms.join(', '), _platformMatch(guess, answer)),
        GameMatchCell(
          '${guess.releaseYear}$yearArrow',
          _exactMatch('${guess.releaseYear}', '${answer.releaseYear}'),
        ),
        GameMatchCell(
          guess.gameMode,
          _exactMatch(guess.gameMode, answer.gameMode),
        ),
        GameMatchCell(
          guess.ageRating,
          _exactMatch(guess.ageRating, answer.ageRating),
        ),
      ],
    );
  }

  static GameMatch _exactMatch(String guess, String answer) =>
      guess == answer ? GameMatch.correct : GameMatch.incorrect;

  static GameMatch _genreMatch(VideoGame guess, VideoGame answer) {
    if (guess.genre == answer.genre) return GameMatch.correct;
    return guess.genreGroup == answer.genreGroup
        ? GameMatch.partial
        : GameMatch.incorrect;
  }

  static GameMatch _platformMatch(VideoGame guess, VideoGame answer) {
    if (_hasSameValues(guess.platforms, answer.platforms)) {
      return GameMatch.correct;
    }
    return guess.platforms.toSet().intersection(answer.platforms.toSet()).isNotEmpty
        ? GameMatch.partial
        : GameMatch.incorrect;
  }

  static bool _hasSameValues(List<String> first, List<String> second) {
    return first.length == second.length && first.toSet().containsAll(second);
  }
}

import 'song.dart';

enum SongMatch { correct, partial, incorrect }

class SongMatchCell {
  final String value;
  final SongMatch match;

  const SongMatchCell(this.value, this.match);
}

class SongGuessResult {
  final Song song;
  final List<SongMatchCell> cells;
  final bool isWin;

  const SongGuessResult({
    required this.song,
    required this.cells,
    required this.isWin,
  });

  factory SongGuessResult.evaluate(Song guess, Song answer) {
    final yearArrow = guess.releaseYear == answer.releaseYear
        ? ''
        : guess.releaseYear < answer.releaseYear
            ? ' ↑'
            : ' ↓';

    return SongGuessResult(
      song: guess,
      isWin: guess.name == answer.name,
      cells: [
        SongMatchCell(guess.name, _exactMatch(guess.name, answer.name)),
        SongMatchCell(guess.artist, _exactMatch(guess.artist, answer.artist)),
        SongMatchCell(guess.country, _exactMatch(guess.country, answer.country)),
        SongMatchCell(guess.genre, _genreMatch(guess, answer)),
        SongMatchCell(
          '${guess.releaseYear}$yearArrow',
          _exactMatch('${guess.releaseYear}', '${answer.releaseYear}'),
        ),
        SongMatchCell(guess.label, _exactMatch(guess.label, answer.label)),
      ],
    );
  }

  static SongMatch _exactMatch(String guess, String answer) =>
      guess == answer ? SongMatch.correct : SongMatch.incorrect;

  static SongMatch _genreMatch(Song guess, Song answer) {
    if (guess.genre == answer.genre) return SongMatch.correct;
    return guess.genreGroup == answer.genreGroup
        ? SongMatch.partial
        : SongMatch.incorrect;
  }
}

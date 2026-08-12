import 'movie.dart';

enum MovieMatch { correct, partial, incorrect }

class MovieMatchCell {
  final String value;
  final MovieMatch match;

  const MovieMatchCell(this.value, this.match);
}

class MovieGuessResult {
  final Movie movie;
  final List<MovieMatchCell> cells;
  final bool isWin;

  const MovieGuessResult({
    required this.movie,
    required this.cells,
    required this.isWin,
  });

  factory MovieGuessResult.evaluate(Movie guess, Movie answer) {
    final yearArrow = guess.releaseYear == answer.releaseYear
        ? ''
        : guess.releaseYear < answer.releaseYear
            ? ' ↑'
            : ' ↓';

    final guessFranchise = guess.franchise ?? '-';
    final answerFranchise = answer.franchise ?? '-';

    return MovieGuessResult(
      movie: guess,
      isWin: guess.name == answer.name,
      cells: [
        MovieMatchCell(guess.name, _exactMatch(guess.name, answer.name)),
        MovieMatchCell(
          guess.director,
          _exactMatch(guess.director, answer.director),
        ),
        MovieMatchCell(guess.country, _exactMatch(guess.country, answer.country)),
        MovieMatchCell(guess.genre, _genreMatch(guess, answer)),
        MovieMatchCell(
          '${guess.releaseYear}$yearArrow',
          _exactMatch('${guess.releaseYear}', '${answer.releaseYear}'),
        ),
        MovieMatchCell(
          guess.studio,
          _exactMatch(guess.studio, answer.studio),
        ),
        MovieMatchCell(
          guessFranchise,
          _exactMatch(guessFranchise, answerFranchise),
        ),
        MovieMatchCell(
          guess.ageRating,
          _exactMatch(guess.ageRating, answer.ageRating),
        ),
      ],
    );
  }

  static MovieMatch _exactMatch(String guess, String answer) =>
      guess == answer ? MovieMatch.correct : MovieMatch.incorrect;

  static MovieMatch _genreMatch(Movie guess, Movie answer) {
    if (guess.genre == answer.genre) return MovieMatch.correct;
    return guess.genreGroup == answer.genreGroup
        ? MovieMatch.partial
        : MovieMatch.incorrect;
  }
}

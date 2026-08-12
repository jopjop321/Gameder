import 'place.dart';

enum PlaceMatch { correct, partial, incorrect }

class PlaceMatchCell {
  final String value;
  final PlaceMatch match;

  const PlaceMatchCell(this.value, this.match);
}

class PlaceGuessResult {
  final Place place;
  final List<PlaceMatchCell> cells;
  final bool isWin;

  const PlaceGuessResult({
    required this.place,
    required this.cells,
    required this.isWin,
  });

  factory PlaceGuessResult.evaluate(
    Place guess,
    Place answer, {
    bool includeRegion = false,
  }) {
    final costArrow = guess.costLevel == answer.costLevel
        ? ''
        : guess.costLevel < answer.costLevel
            ? ' ↑'
            : ' ↓';

    return PlaceGuessResult(
      place: guess,
      isWin: guess.name == answer.name,
      cells: [
        PlaceMatchCell(guess.displayName, _exactMatch(guess.name, answer.name)),
        PlaceMatchCell(guess.displayCountry, _countryMatch(guess, answer)),
        if (includeRegion)
          PlaceMatchCell(
            guess.displayRegion ?? '-',
            _regionMatch(guess, answer),
          ),
        PlaceMatchCell(
          guess.displayPlaceType,
          _exactMatch(guess.placeType, answer.placeType),
        ),
        PlaceMatchCell(guess.displayMainFeature, _featureMatch(guess, answer)),
        PlaceMatchCell(
          guess.displayActivity,
          _exactMatch(guess.activity, answer.activity),
        ),
        PlaceMatchCell(
          guess.displayHighlights.join(', '),
          _highlightMatch(guess, answer),
        ),
        PlaceMatchCell(
          '${guess.costLevel}$costArrow',
          _exactMatch('${guess.costLevel}', '${answer.costLevel}'),
        ),
      ],
    );
  }

  static PlaceMatch _exactMatch(String guess, String answer) =>
      guess == answer ? PlaceMatch.correct : PlaceMatch.incorrect;

  static PlaceMatch _countryMatch(Place guess, Place answer) {
    if (guess.country == answer.country) return PlaceMatch.correct;
    return guess.continent == answer.continent
        ? PlaceMatch.partial
        : PlaceMatch.incorrect;
  }

  static PlaceMatch _regionMatch(Place guess, Place answer) =>
      guess.region == answer.region ? PlaceMatch.correct : PlaceMatch.incorrect;

  static PlaceMatch _featureMatch(Place guess, Place answer) {
    if (guess.mainFeature == answer.mainFeature) return PlaceMatch.correct;
    return guess.featureGroup == answer.featureGroup
        ? PlaceMatch.partial
        : PlaceMatch.incorrect;
  }

  static PlaceMatch _highlightMatch(Place guess, Place answer) {
    if (_hasSameValues(guess.highlights, answer.highlights)) {
      return PlaceMatch.correct;
    }
    return guess.highlights.toSet().intersection(answer.highlights.toSet()).isNotEmpty
        ? PlaceMatch.partial
        : PlaceMatch.incorrect;
  }

  static bool _hasSameValues(List<String> first, List<String> second) {
    return first.length == second.length && first.toSet().containsAll(second);
  }
}

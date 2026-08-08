import 'food.dart';

enum FoodMatch { correct, partial, incorrect }

class FoodMatchCell {
  final String value;
  final FoodMatch match;

  const FoodMatchCell(this.value, this.match);
}

class FoodGuessResult {
  final Food food;
  final List<FoodMatchCell> cells;
  final bool isWin;

  const FoodGuessResult({
    required this.food,
    required this.cells,
    required this.isWin,
  });

  factory FoodGuessResult.evaluate(
    Food guess,
    Food answer, {
    bool includeRegion = false,
  }) {
    final spiceArrow = guess.spiceLevel == answer.spiceLevel
        ? ''
        : guess.spiceLevel < answer.spiceLevel
            ? ' ↑'
            : ' ↓';

    return FoodGuessResult(
      food: guess,
      isWin: guess.name == answer.name,
      cells: [
        FoodMatchCell(guess.name, _exactMatch(guess.name, answer.name)),
        FoodMatchCell(guess.country, _countryMatch(guess, answer)),
        if (includeRegion)
          FoodMatchCell(guess.region ?? '-', _regionMatch(guess, answer)),
        FoodMatchCell(
          guess.dishType,
          _exactMatch(guess.dishType, answer.dishType),
        ),
        FoodMatchCell(guess.mainIngredient, _ingredientMatch(guess, answer)),
        FoodMatchCell(
          guess.cookingMethod,
          _exactMatch(guess.cookingMethod, answer.cookingMethod),
        ),
        FoodMatchCell(guess.flavors.join(', '), _flavorMatch(guess, answer)),
        FoodMatchCell(
          '${guess.spiceLevel}$spiceArrow',
          _exactMatch('${guess.spiceLevel}', '${answer.spiceLevel}'),
        ),
      ],
    );
  }

  static FoodMatch _exactMatch(String guess, String answer) =>
      guess == answer ? FoodMatch.correct : FoodMatch.incorrect;

  static FoodMatch _countryMatch(Food guess, Food answer) {
    if (guess.country == answer.country) return FoodMatch.correct;
    return guess.continent == answer.continent
        ? FoodMatch.partial
        : FoodMatch.incorrect;
  }

  static FoodMatch _regionMatch(Food guess, Food answer) =>
      guess.region == answer.region ? FoodMatch.correct : FoodMatch.incorrect;

  static FoodMatch _ingredientMatch(Food guess, Food answer) {
    if (guess.mainIngredient == answer.mainIngredient) return FoodMatch.correct;
    return guess.ingredientGroup == answer.ingredientGroup
        ? FoodMatch.partial
        : FoodMatch.incorrect;
  }

  static FoodMatch _flavorMatch(Food guess, Food answer) {
    if (_hasSameValues(guess.flavors, answer.flavors)) return FoodMatch.correct;
    return guess.flavors.toSet().intersection(answer.flavors.toSet()).isNotEmpty
        ? FoodMatch.partial
        : FoodMatch.incorrect;
  }

  static bool _hasSameValues(List<String> first, List<String> second) {
    return first.length == second.length && first.toSet().containsAll(second);
  }
}

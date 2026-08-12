import 'car.dart';

enum CarMatch { correct, partial, incorrect }

class CarMatchCell {
  final String value;
  final CarMatch match;

  const CarMatchCell(this.value, this.match);
}

class CarGuessResult {
  final Car car;
  final List<CarMatchCell> cells;
  final bool isWin;

  const CarGuessResult({
    required this.car,
    required this.cells,
    required this.isWin,
  });

  factory CarGuessResult.evaluate(Car guess, Car answer) {
    final yearArrow = guess.launchYear == answer.launchYear
        ? ''
        : guess.launchYear < answer.launchYear
            ? ' ↑'
            : ' ↓';

    return CarGuessResult(
      car: guess,
      isWin: guess.name == answer.name,
      cells: [
        CarMatchCell(guess.name, _exactMatch(guess.name, answer.name)),
        CarMatchCell(guess.brand, _exactMatch(guess.brand, answer.brand)),
        CarMatchCell(guess.country, _exactMatch(guess.country, answer.country)),
        CarMatchCell(
          guess.bodyType,
          _exactMatch(guess.bodyType, answer.bodyType),
        ),
        CarMatchCell(
          guess.fuelType,
          _exactMatch(guess.fuelType, answer.fuelType),
        ),
        CarMatchCell(
          guess.priceSegment,
          _exactMatch(guess.priceSegment, answer.priceSegment),
        ),
        CarMatchCell(
          '${guess.launchYear}$yearArrow',
          _exactMatch('${guess.launchYear}', '${answer.launchYear}'),
        ),
      ],
    );
  }

  static CarMatch _exactMatch(String guess, String answer) =>
      guess == answer ? CarMatch.correct : CarMatch.incorrect;
}

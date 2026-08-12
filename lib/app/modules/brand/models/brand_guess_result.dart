import 'brand.dart';

enum BrandMatch { correct, partial, incorrect }

class BrandMatchCell {
  final String value;
  final BrandMatch match;

  const BrandMatchCell(this.value, this.match);
}

class BrandGuessResult {
  final Brand brand;
  final List<BrandMatchCell> cells;
  final bool isWin;

  const BrandGuessResult({
    required this.brand,
    required this.cells,
    required this.isWin,
  });

  factory BrandGuessResult.evaluate(Brand guess, Brand answer) {
    final yearArrow = guess.foundedYear == answer.foundedYear
        ? ''
        : guess.foundedYear < answer.foundedYear
            ? ' ↑'
            : ' ↓';
    final guessParent = guess.parentCompany ?? '-';
    final answerParent = answer.parentCompany ?? '-';

    return BrandGuessResult(
      brand: guess,
      isWin: guess.name == answer.name,
      cells: [
        BrandMatchCell(guess.name, _exactMatch(guess.name, answer.name)),
        BrandMatchCell(guess.industry, _industryMatch(guess, answer)),
        BrandMatchCell(guess.country, _exactMatch(guess.country, answer.country)),
        BrandMatchCell(
          guess.headquartersCity,
          _exactMatch(guess.headquartersCity, answer.headquartersCity),
        ),
        BrandMatchCell(
          guess.ownershipType,
          _exactMatch(guess.ownershipType, answer.ownershipType),
        ),
        BrandMatchCell(guessParent, _exactMatch(guessParent, answerParent)),
        BrandMatchCell(
          '${guess.foundedYear}$yearArrow',
          _exactMatch('${guess.foundedYear}', '${answer.foundedYear}'),
        ),
      ],
    );
  }

  static BrandMatch _exactMatch(String guess, String answer) =>
      guess == answer ? BrandMatch.correct : BrandMatch.incorrect;

  static BrandMatch _industryMatch(Brand guess, Brand answer) {
    if (guess.industry == answer.industry) return BrandMatch.correct;
    return guess.industryGroup == answer.industryGroup
        ? BrandMatch.partial
        : BrandMatch.incorrect;
  }
}

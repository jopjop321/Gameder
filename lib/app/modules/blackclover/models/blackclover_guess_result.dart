import 'blackclover_character.dart';

enum BlackcloverMatch { correct, partial, incorrect }

class BlackcloverMatchCell {
  final String value;
  final BlackcloverMatch match;

  const BlackcloverMatchCell(this.value, this.match);
}

class BlackcloverGuessResult {
  final BlackcloverCharacter character;
  final List<BlackcloverMatchCell> cells;
  final bool isWin;

  const BlackcloverGuessResult({
    required this.character,
    required this.cells,
    required this.isWin,
  });

  factory BlackcloverGuessResult.evaluate(
    BlackcloverCharacter guess,
    BlackcloverCharacter answer,
  ) {
    final sagaArrow = guess.sagaOrder == answer.sagaOrder
        ? ''
        : guess.sagaOrder < answer.sagaOrder
            ? ' ↑'
            : ' ↓';

    return BlackcloverGuessResult(
      character: guess,
      isWin: guess.name == answer.name,
      cells: [
        BlackcloverMatchCell(guess.displayName, _exactMatch(guess.name, answer.name)),
        BlackcloverMatchCell(
          guess.displaySquad,
          _exactMatch(guess.squad, answer.squad),
        ),
        BlackcloverMatchCell(
          guess.displayMagicType,
          _exactMatch(guess.magicType, answer.magicType),
        ),
        BlackcloverMatchCell(
          guess.displayGrimoireClover,
          _exactMatch(guess.grimoireClover, answer.grimoireClover),
        ),
        BlackcloverMatchCell(guess.displayRole, _exactMatch(guess.role, answer.role)),
        BlackcloverMatchCell(
          guess.displayWeaponType,
          _exactMatch(guess.weaponType, answer.weaponType),
        ),
        BlackcloverMatchCell(
          guess.displayGender,
          _exactMatch(guess.gender, answer.gender),
        ),
        BlackcloverMatchCell(
          guess.displayKingdom,
          _exactMatch(guess.kingdom, answer.kingdom),
        ),
        BlackcloverMatchCell(
          '${guess.displaySaga}$sagaArrow',
          _exactMatch(guess.saga, answer.saga),
        ),
      ],
    );
  }

  static BlackcloverMatch _exactMatch(String guess, String answer) =>
      guess == answer ? BlackcloverMatch.correct : BlackcloverMatch.incorrect;
}

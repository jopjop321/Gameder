import 'demonslayer_character.dart';

enum DemonslayerMatch { correct, partial, incorrect }

class DemonslayerMatchCell {
  final String value;
  final DemonslayerMatch match;

  const DemonslayerMatchCell(this.value, this.match);
}

class DemonslayerGuessResult {
  final DemonslayerCharacter character;
  final List<DemonslayerMatchCell> cells;
  final bool isWin;

  const DemonslayerGuessResult({
    required this.character,
    required this.cells,
    required this.isWin,
  });

  factory DemonslayerGuessResult.evaluate(
    DemonslayerCharacter guess,
    DemonslayerCharacter answer,
  ) {
    final sagaArrow = guess.sagaOrder == answer.sagaOrder
        ? ''
        : guess.sagaOrder < answer.sagaOrder
            ? ' ↑'
            : ' ↓';

    return DemonslayerGuessResult(
      character: guess,
      isWin: guess.name == answer.name,
      cells: [
        DemonslayerMatchCell(
          guess.displayName,
          _exactMatch(guess.name, answer.name),
        ),
        DemonslayerMatchCell(
          guess.displayCorps,
          _exactMatch(guess.corps, answer.corps),
        ),
        DemonslayerMatchCell(
          guess.displayBreathingStyle,
          _exactMatch(guess.breathingStyle, answer.breathingStyle),
        ),
        DemonslayerMatchCell(
          guess.displayRank,
          _exactMatch(guess.rank, answer.rank),
        ),
        DemonslayerMatchCell(
          guess.displaySpecies,
          _exactMatch(guess.species, answer.species),
        ),
        DemonslayerMatchCell(
          guess.displayWeaponType,
          _exactMatch(guess.weaponType, answer.weaponType),
        ),
        DemonslayerMatchCell(
          guess.displayGender,
          _exactMatch(guess.gender, answer.gender),
        ),
        DemonslayerMatchCell(
          guess.displaySwordColor,
          _exactMatch(guess.swordColor, answer.swordColor),
        ),
        DemonslayerMatchCell(
          '${guess.displaySaga}$sagaArrow',
          _exactMatch(guess.saga, answer.saga),
        ),
      ],
    );
  }

  static DemonslayerMatch _exactMatch(String guess, String answer) =>
      guess == answer ? DemonslayerMatch.correct : DemonslayerMatch.incorrect;
}

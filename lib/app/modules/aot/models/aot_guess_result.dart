import 'aot_character.dart';

enum AotMatch { correct, partial, incorrect }

class AotMatchCell {
  final String value;
  final AotMatch match;

  const AotMatchCell(this.value, this.match);
}

class AotGuessResult {
  final AotCharacter character;
  final List<AotMatchCell> cells;
  final bool isWin;

  const AotGuessResult({
    required this.character,
    required this.cells,
    required this.isWin,
  });

  factory AotGuessResult.evaluate(AotCharacter guess, AotCharacter answer) {
    final sagaArrow = guess.sagaOrder == answer.sagaOrder
        ? ''
        : guess.sagaOrder < answer.sagaOrder
            ? ' ↑'
            : ' ↓';

    return AotGuessResult(
      character: guess,
      isWin: guess.name == answer.name,
      cells: [
        AotMatchCell(guess.displayName, _exactMatch(guess.name, answer.name)),
        AotMatchCell(
          guess.displayAffiliation,
          _exactMatch(guess.affiliation, answer.affiliation),
        ),
        AotMatchCell(
          guess.displayTitanType,
          _exactMatch(guess.titanType, answer.titanType),
        ),
        AotMatchCell(guess.displayRank, _exactMatch(guess.rank, answer.rank)),
        AotMatchCell(
          guess.displayWeaponType,
          _exactMatch(guess.weaponType, answer.weaponType),
        ),
        AotMatchCell(
          guess.displaySpecies,
          _exactMatch(guess.species, answer.species),
        ),
        AotMatchCell(
          guess.displayGender,
          _exactMatch(guess.gender, answer.gender),
        ),
        AotMatchCell(
          guess.displayOrigin,
          _exactMatch(guess.origin, answer.origin),
        ),
        AotMatchCell(
          '${guess.displaySaga}$sagaArrow',
          _exactMatch(guess.saga, answer.saga),
        ),
      ],
    );
  }

  static AotMatch _exactMatch(String guess, String answer) =>
      guess == answer ? AotMatch.correct : AotMatch.incorrect;
}

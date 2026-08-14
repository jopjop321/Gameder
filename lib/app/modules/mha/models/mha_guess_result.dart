import 'mha_character.dart';

enum MhaMatch { correct, partial, incorrect }

class MhaMatchCell {
  final String value;
  final MhaMatch match;

  const MhaMatchCell(this.value, this.match);
}

class MhaGuessResult {
  final MhaCharacter character;
  final List<MhaMatchCell> cells;
  final bool isWin;

  const MhaGuessResult({
    required this.character,
    required this.cells,
    required this.isWin,
  });

  factory MhaGuessResult.evaluate(MhaCharacter guess, MhaCharacter answer) {
    final sagaArrow = guess.sagaOrder == answer.sagaOrder
        ? ''
        : guess.sagaOrder < answer.sagaOrder
            ? ' ↑'
            : ' ↓';

    return MhaGuessResult(
      character: guess,
      isWin: guess.name == answer.name,
      cells: [
        MhaMatchCell(guess.displayName, _exactMatch(guess.name, answer.name)),
        MhaMatchCell(
          guess.displayAffiliation,
          _exactMatch(guess.affiliation, answer.affiliation),
        ),
        MhaMatchCell(
          guess.displayQuirkType,
          _exactMatch(guess.quirkType, answer.quirkType),
        ),
        MhaMatchCell(
          guess.displayQuirkName,
          _exactMatch(guess.quirkName, answer.quirkName),
        ),
        MhaMatchCell(guess.displayRole, _exactMatch(guess.role, answer.role)),
        MhaMatchCell(
          guess.displayWeaponType,
          _exactMatch(guess.weaponType, answer.weaponType),
        ),
        MhaMatchCell(
          guess.displayGender,
          _exactMatch(guess.gender, answer.gender),
        ),
        MhaMatchCell(
          guess.displayHeroName,
          _exactMatch(guess.heroName, answer.heroName),
        ),
        MhaMatchCell(
          '${guess.displaySaga}$sagaArrow',
          _exactMatch(guess.saga, answer.saga),
        ),
      ],
    );
  }

  static MhaMatch _exactMatch(String guess, String answer) =>
      guess == answer ? MhaMatch.correct : MhaMatch.incorrect;
}

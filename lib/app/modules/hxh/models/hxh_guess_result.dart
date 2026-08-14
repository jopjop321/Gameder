import 'hxh_character.dart';

enum HxhMatch { correct, partial, incorrect }

class HxhMatchCell {
  final String value;
  final HxhMatch match;

  const HxhMatchCell(this.value, this.match);
}

class HxhGuessResult {
  final HxhCharacter character;
  final List<HxhMatchCell> cells;
  final bool isWin;

  const HxhGuessResult({
    required this.character,
    required this.cells,
    required this.isWin,
  });

  factory HxhGuessResult.evaluate(
    HxhCharacter guess,
    HxhCharacter answer,
  ) {
    final sagaArrow = guess.sagaOrder == answer.sagaOrder
        ? ''
        : guess.sagaOrder < answer.sagaOrder
            ? ' ↑'
            : ' ↓';

    return HxhGuessResult(
      character: guess,
      isWin: guess.name == answer.name,
      cells: [
        HxhMatchCell(guess.displayName, _exactMatch(guess.name, answer.name)),
        HxhMatchCell(
          guess.displayAffiliation,
          _exactMatch(guess.affiliation, answer.affiliation),
        ),
        HxhMatchCell(
          guess.displayNenType,
          _exactMatch(guess.nenType, answer.nenType),
        ),
        HxhMatchCell(
          guess.displayHunterLicense,
          _exactMatch(guess.hunterLicense, answer.hunterLicense),
        ),
        HxhMatchCell(guess.displayRole, _exactMatch(guess.role, answer.role)),
        HxhMatchCell(
          guess.displayWeaponType,
          _exactMatch(guess.weaponType, answer.weaponType),
        ),
        HxhMatchCell(
          guess.displayGender,
          _exactMatch(guess.gender, answer.gender),
        ),
        HxhMatchCell(
          guess.displayHatsuName,
          _exactMatch(guess.hatsuName, answer.hatsuName),
        ),
        HxhMatchCell(
          '${guess.displaySaga}$sagaArrow',
          _exactMatch(guess.saga, answer.saga),
        ),
      ],
    );
  }

  static HxhMatch _exactMatch(String guess, String answer) =>
      guess == answer ? HxhMatch.correct : HxhMatch.incorrect;
}

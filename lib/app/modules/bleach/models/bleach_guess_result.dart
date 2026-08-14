import 'bleach_character.dart';

enum BleachMatch { correct, partial, incorrect }

class BleachMatchCell {
  final String value;
  final BleachMatch match;

  const BleachMatchCell(this.value, this.match);
}

class BleachGuessResult {
  final BleachCharacter character;
  final List<BleachMatchCell> cells;
  final bool isWin;

  const BleachGuessResult({
    required this.character,
    required this.cells,
    required this.isWin,
  });

  factory BleachGuessResult.evaluate(
    BleachCharacter guess,
    BleachCharacter answer,
  ) {
    final sagaArrow = guess.sagaOrder == answer.sagaOrder
        ? ''
        : guess.sagaOrder < answer.sagaOrder
            ? ' ↑'
            : ' ↓';

    return BleachGuessResult(
      character: guess,
      isWin: guess.name == answer.name,
      cells: [
        BleachMatchCell(guess.displayName, _exactMatch(guess.name, answer.name)),
        BleachMatchCell(
          guess.displayAffiliation,
          _exactMatch(guess.affiliation, answer.affiliation),
        ),
        BleachMatchCell(
          guess.displayRace,
          _exactMatch(guess.race, answer.race),
        ),
        BleachMatchCell(
          guess.displayZanpakutoName,
          _exactMatch(guess.zanpakutoName, answer.zanpakutoName),
        ),
        BleachMatchCell(guess.displayRank, _exactMatch(guess.rank, answer.rank)),
        BleachMatchCell(
          guess.displayWeaponType,
          _exactMatch(guess.weaponType, answer.weaponType),
        ),
        BleachMatchCell(
          guess.displayGender,
          _exactMatch(guess.gender, answer.gender),
        ),
        BleachMatchCell(
          guess.displayShikaiBankai,
          _exactMatch(guess.shikaiBankai, answer.shikaiBankai),
        ),
        BleachMatchCell(
          '${guess.displaySaga}$sagaArrow',
          _exactMatch(guess.saga, answer.saga),
        ),
      ],
    );
  }

  static BleachMatch _exactMatch(String guess, String answer) =>
      guess == answer ? BleachMatch.correct : BleachMatch.incorrect;
}

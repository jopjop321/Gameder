import 'naruto_character.dart';

enum NarutoMatch { correct, partial, incorrect }

class NarutoMatchCell {
  final String value;
  final NarutoMatch match;

  const NarutoMatchCell(this.value, this.match);
}

class NarutoGuessResult {
  final NarutoCharacter character;
  final List<NarutoMatchCell> cells;
  final bool isWin;

  const NarutoGuessResult({
    required this.character,
    required this.cells,
    required this.isWin,
  });

  factory NarutoGuessResult.evaluate(
    NarutoCharacter guess,
    NarutoCharacter answer,
  ) {
    final sagaArrow = guess.sagaOrder == answer.sagaOrder
        ? ''
        : guess.sagaOrder < answer.sagaOrder
            ? ' ↑'
            : ' ↓';

    return NarutoGuessResult(
      character: guess,
      isWin: guess.name == answer.name,
      cells: [
        NarutoMatchCell(guess.displayName, _exactMatch(guess.name, answer.name)),
        NarutoMatchCell(
          guess.displayVillage,
          _exactMatch(guess.village, answer.village),
        ),
        NarutoMatchCell(
          guess.displayClan,
          _exactMatch(guess.clan, answer.clan),
        ),
        NarutoMatchCell(
          guess.displayChakraNature,
          _exactMatch(guess.chakraNature, answer.chakraNature),
        ),
        NarutoMatchCell(guess.displayRank, _exactMatch(guess.rank, answer.rank)),
        NarutoMatchCell(guess.displayTeam, _exactMatch(guess.team, answer.team)),
        NarutoMatchCell(
          guess.displayWeaponType,
          _exactMatch(guess.weaponType, answer.weaponType),
        ),
        NarutoMatchCell(
          guess.displayGender,
          _exactMatch(guess.gender, answer.gender),
        ),
        NarutoMatchCell(
          guess.displayBijuu,
          _exactMatch(guess.bijuu, answer.bijuu),
        ),
        NarutoMatchCell(
          '${guess.displaySaga}$sagaArrow',
          _exactMatch(guess.saga, answer.saga),
        ),
      ],
    );
  }

  static NarutoMatch _exactMatch(String guess, String answer) =>
      guess == answer ? NarutoMatch.correct : NarutoMatch.incorrect;
}

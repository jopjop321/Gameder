import 'onepiece_character.dart';

enum OnePieceMatch { correct, partial, incorrect }

class OnePieceMatchCell {
  final String value;
  final OnePieceMatch match;

  const OnePieceMatchCell(this.value, this.match);
}

class OnePieceGuessResult {
  final OnePieceCharacter character;
  final List<OnePieceMatchCell> cells;
  final bool isWin;

  const OnePieceGuessResult({
    required this.character,
    required this.cells,
    required this.isWin,
  });

  factory OnePieceGuessResult.evaluate(
    OnePieceCharacter guess,
    OnePieceCharacter answer,
  ) {
    final sagaArrow = guess.sagaOrder == answer.sagaOrder
        ? ''
        : guess.sagaOrder < answer.sagaOrder
            ? ' ↑'
            : ' ↓';

    final bountyArrow = (guess.bounty == null || answer.bounty == null)
        ? ''
        : guess.bounty == answer.bounty
            ? ''
            : guess.bounty! < answer.bounty!
                ? ' ↑'
                : ' ↓';

    return OnePieceGuessResult(
      character: guess,
      isWin: guess.name == answer.name,
      cells: [
        OnePieceMatchCell(guess.displayName, _exactMatch(guess.name, answer.name)),
        OnePieceMatchCell(
          guess.displayCrew,
          _exactMatch(guess.crew, answer.crew),
        ),
        OnePieceMatchCell(
          guess.displayDevilFruitType,
          _exactMatch(guess.devilFruitType, answer.devilFruitType),
        ),
        OnePieceMatchCell(
          guess.displayDevilFruitName,
          _exactMatch(guess.devilFruitName, answer.devilFruitName),
        ),
        OnePieceMatchCell(guess.displayRole, _exactMatch(guess.role, answer.role)),
        OnePieceMatchCell(
          guess.displayWeaponType,
          _exactMatch(guess.weaponType, answer.weaponType),
        ),
        OnePieceMatchCell(
          guess.displaySpecies,
          _exactMatch(guess.species, answer.species),
        ),
        OnePieceMatchCell(
          guess.displayGender,
          _exactMatch(guess.gender, answer.gender),
        ),
        OnePieceMatchCell(
          '${guess.displayBounty}$bountyArrow',
          _bountyMatch(guess.bounty, answer.bounty),
        ),
        OnePieceMatchCell(
          '${guess.displaySaga}$sagaArrow',
          _exactMatch(guess.saga, answer.saga),
        ),
      ],
    );
  }

  static OnePieceMatch _exactMatch(String guess, String answer) =>
      guess == answer ? OnePieceMatch.correct : OnePieceMatch.incorrect;

  static OnePieceMatch _bountyMatch(int? guess, int? answer) =>
      guess != null && answer != null && guess == answer
          ? OnePieceMatch.correct
          : OnePieceMatch.incorrect;
}

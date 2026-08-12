import 'reborn_character.dart';

enum RebornMatch { correct, partial, incorrect }

class RebornMatchCell {
  final String value;
  final RebornMatch match;

  const RebornMatchCell(this.value, this.match);
}

class RebornGuessResult {
  final RebornCharacter character;
  final List<RebornMatchCell> cells;
  final bool isWin;

  const RebornGuessResult({
    required this.character,
    required this.cells,
    required this.isWin,
  });

  factory RebornGuessResult.evaluate(RebornCharacter guess, RebornCharacter answer) {
    final arcArrow = guess.arcOrder == answer.arcOrder
        ? ''
        : guess.arcOrder < answer.arcOrder
            ? ' ↑'
            : ' ↓';

    return RebornGuessResult(
      character: guess,
      isWin: guess.name == answer.name,
      cells: [
        RebornMatchCell(guess.displayName, _exactMatch(guess.name, answer.name)),
        RebornMatchCell(
          guess.displayFamily,
          _exactMatch(guess.family, answer.family),
        ),
        RebornMatchCell(
          guess.displayFlameAttribute,
          _exactMatch(guess.flameAttribute, answer.flameAttribute),
        ),
        RebornMatchCell(guess.displayRole, _exactMatch(guess.role, answer.role)),
        RebornMatchCell(
          guess.displayBoxAnimal,
          _exactMatch(guess.boxAnimal, answer.boxAnimal),
        ),
        RebornMatchCell(
          guess.displayWeaponType,
          _exactMatch(guess.weaponType, answer.weaponType),
        ),
        RebornMatchCell(
          guess.displaySpecies,
          _exactMatch(guess.species, answer.species),
        ),
        RebornMatchCell(
          guess.displayGender,
          _exactMatch(guess.gender, answer.gender),
        ),
        RebornMatchCell(
          '${guess.displayFirstArc}$arcArrow',
          _exactMatch(guess.firstArc, answer.firstArc),
        ),
      ],
    );
  }

  static RebornMatch _exactMatch(String guess, String answer) =>
      guess == answer ? RebornMatch.correct : RebornMatch.incorrect;
}

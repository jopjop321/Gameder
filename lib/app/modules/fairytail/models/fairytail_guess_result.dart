import 'fairytail_character.dart';

enum FairytailMatch { correct, partial, incorrect }

class FairytailMatchCell {
  final String value;
  final FairytailMatch match;

  const FairytailMatchCell(this.value, this.match);
}

class FairytailGuessResult {
  final FairytailCharacter character;
  final List<FairytailMatchCell> cells;
  final bool isWin;

  const FairytailGuessResult({
    required this.character,
    required this.cells,
    required this.isWin,
  });

  factory FairytailGuessResult.evaluate(
    FairytailCharacter guess,
    FairytailCharacter answer,
  ) {
    final sagaArrow = guess.sagaOrder == answer.sagaOrder
        ? ''
        : guess.sagaOrder < answer.sagaOrder
            ? ' ↑'
            : ' ↓';

    return FairytailGuessResult(
      character: guess,
      isWin: guess.name == answer.name,
      cells: [
        FairytailMatchCell(
          guess.displayName,
          _exactMatch(guess.name, answer.name),
        ),
        FairytailMatchCell(
          guess.displayGuild,
          _exactMatch(guess.guild, answer.guild),
        ),
        FairytailMatchCell(
          guess.displayMagicType,
          _exactMatch(guess.magicType, answer.magicType),
        ),
        FairytailMatchCell(
          guess.displayTeam,
          _exactMatch(guess.team, answer.team),
        ),
        FairytailMatchCell(
          guess.displayGuildRank,
          _exactMatch(guess.guildRank, answer.guildRank),
        ),
        FairytailMatchCell(
          guess.displayWeaponType,
          _exactMatch(guess.weaponType, answer.weaponType),
        ),
        FairytailMatchCell(
          guess.displayGender,
          _exactMatch(guess.gender, answer.gender),
        ),
        FairytailMatchCell(
          guess.displayGuildMarkColor,
          _exactMatch(guess.guildMarkColor, answer.guildMarkColor),
        ),
        FairytailMatchCell(
          '${guess.displaySaga}$sagaArrow',
          _exactMatch(guess.saga, answer.saga),
        ),
      ],
    );
  }

  static FairytailMatch _exactMatch(String guess, String answer) =>
      guess == answer ? FairytailMatch.correct : FairytailMatch.incorrect;
}

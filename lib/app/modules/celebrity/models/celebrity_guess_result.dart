import 'package:get/get.dart';

import 'celebrity.dart';

enum CelebrityMatch { correct, partial, incorrect }

class CelebrityMatchCell {
  final String value;
  final CelebrityMatch match;

  const CelebrityMatchCell(this.value, this.match);
}

const Map<CelebrityCollection, String> _celebrityCollectionKeys = {
  CelebrityCollection.youtuber: 'celebrity_youtuber',
  CelebrityCollection.globalYoutuber: 'celebrity_youtuberGlobal',
  CelebrityCollection.actor: 'celebrity_actor',
  CelebrityCollection.singer: 'celebrity_singer',
  CelebrityCollection.athlete: 'celebrity_athlete',
  CelebrityCollection.kpopIdol: 'celebrity_kpopIdol',
  CelebrityCollection.ySeriesActor: 'celebrity_ySeriesActor',
  CelebrityCollection.koreanActor: 'celebrity_koreanActor',
};

/// Locale-aware label for a celebrity collection (e.g. YouTuber, Actor).
String celebrityCollectionLabel(CelebrityCollection collection) =>
    (_celebrityCollectionKeys[collection] ?? '').tr;

class CelebrityGuessResult {
  final Celebrity celebrity;
  final List<CelebrityMatchCell> cells;
  final bool isWin;

  const CelebrityGuessResult({
    required this.celebrity,
    required this.cells,
    required this.isWin,
  });

  factory CelebrityGuessResult.evaluate(
    Celebrity guess,
    Celebrity answer, {
    bool includeOccupation = false,
    bool includeYoutuberFields = false,
  }) {
    final nameCell = CelebrityMatchCell(
      guess.displayName,
      _exactMatch(guess.name, answer.name),
    );
    final occupationCell = CelebrityMatchCell(
      celebrityCollectionLabel(guess.collection),
      _exactMatch(guess.collection.name, answer.collection.name),
    );
    final subCategoryCell = CelebrityMatchCell(
      guess.displaySubCategory,
      _exactMatch(guess.subCategory, answer.subCategory),
    );
    final channelTypeCell = CelebrityMatchCell(
      guess.displayChannelType ?? '-',
      _exactMatch(guess.channelType ?? '', answer.channelType ?? ''),
    );
    final genderCell = CelebrityMatchCell(
      guess.displayGender,
      _exactMatch(guess.gender, answer.gender),
    );
    final subscriberCell = CelebrityMatchCell(
      '${guess.subscriberTier ?? '-'}${_tierArrow(guess.subscriberTier, answer.subscriberTier)}',
      _exactMatch(guess.subscriberTier ?? '', answer.subscriberTier ?? ''),
    );
    final debutCell = CelebrityMatchCell(
      '${guess.debutYear}${_numArrow(guess.debutYear, answer.debutYear)}',
      _exactMatch('${guess.debutYear}', '${answer.debutYear}'),
    );
    final regionCell = CelebrityMatchCell(
      guess.displayRegion,
      _exactMatch(guess.region, answer.region),
    );
    final agencyCell = CelebrityMatchCell(
      guess.displayAgency,
      _exactMatch(guess.agency, answer.agency),
    );

    final cells = includeYoutuberFields
        ? [
            nameCell,
            subCategoryCell,
            channelTypeCell,
            genderCell,
            subscriberCell,
            debutCell,
            regionCell,
            agencyCell,
          ]
        : [
            nameCell,
            if (includeOccupation) occupationCell,
            genderCell,
            subCategoryCell,
            regionCell,
            agencyCell,
            debutCell,
          ];

    return CelebrityGuessResult(
      celebrity: guess,
      isWin: guess.name == answer.name,
      cells: cells,
    );
  }

  static const _tierOrder = [
    '<100K',
    '100K-500K',
    '500K-1M',
    '1M-5M',
    '5M-10M',
    '10M+',
  ];

  static String _tierArrow(String? guess, String? answer) {
    if (guess == null || answer == null) return '';
    final guessRank = _tierOrder.indexOf(guess);
    final answerRank = _tierOrder.indexOf(answer);
    if (guessRank == -1 || answerRank == -1 || guessRank == answerRank) {
      return '';
    }
    return guessRank < answerRank ? ' ↑' : ' ↓';
  }

  static String _numArrow(int guess, int answer) {
    if (guess == answer) return '';
    return guess < answer ? ' ↑' : ' ↓';
  }

  static CelebrityMatch _exactMatch(String guess, String answer) =>
      guess == answer ? CelebrityMatch.correct : CelebrityMatch.incorrect;
}

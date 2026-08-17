import 'package:flutter/material.dart';

import '../models/celebrity_guess_result.dart';
import '../theme/celebrity_theme.dart';

class CelebrityKnownFactsRow extends StatelessWidget {
  final List<CelebrityGuessResult> guesses;
  final bool includeOccupation;
  final bool includeYoutuberFields;

  const CelebrityKnownFactsRow({
    super.key,
    required this.guesses,
    this.includeOccupation = false,
    this.includeYoutuberFields = false,
  });

  int _rank(CelebrityMatch match) {
    switch (match) {
      case CelebrityMatch.correct:
        return 2;
      case CelebrityMatch.partial:
        return 1;
      case CelebrityMatch.incorrect:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final columnCount = celebrityColumnLabels(
      includeOccupation: includeOccupation,
      includeYoutuberFields: includeYoutuberFields,
    ).length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: List.generate(columnCount, (i) {
          if (i == 0) return _placeholderCell();
          return _summaryCell(i);
        }),
      ),
    );
  }

  Widget _placeholderCell() {
    return _cellShell(
      color: kCelebrityHeaderCellColor,
      bordered: true,
      child: const Text(
        '?',
        style: TextStyle(
          color: Colors.white38,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _summaryCell(int columnIndex) {
    if (guesses.isEmpty) {
      return _cellShell(
        color: kCelebrityHeaderCellColor,
        bordered: true,
        child: const Text(
          '?',
          style: TextStyle(color: Colors.white38, fontSize: 16),
        ),
      );
    }

    var best = guesses.first.cells[columnIndex];
    for (final g in guesses) {
      final cell = g.cells[columnIndex];
      if (_rank(cell.match) > _rank(best.match)) best = cell;
    }

    final color = switch (best.match) {
      CelebrityMatch.correct => kCelebrityCorrectColor,
      CelebrityMatch.partial => kCelebrityPartialColor,
      CelebrityMatch.incorrect => kCelebrityIncorrectColor,
    };
    final display = best.match == CelebrityMatch.correct ? best.value : '?';

    return _cellShell(
      color: color,
      child: Text(
        display,
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _cellShell({
    required Color color,
    required Widget child,
    bool bordered = false,
  }) {
    return Container(
      width: 98,
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.all(6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: bordered ? Border.all(color: Colors.white24) : null,
      ),
      child: child,
    );
  }
}

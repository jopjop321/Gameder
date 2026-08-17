import 'package:flutter/material.dart';

import '../models/fairytail_guess_result.dart';
import '../theme/fairydle_theme.dart';

class FairydleKnownFactsRow extends StatelessWidget {
  final List<FairytailGuessResult> guesses;

  const FairydleKnownFactsRow({super.key, required this.guesses});

  int _rank(FairytailMatch match) {
    switch (match) {
      case FairytailMatch.correct:
        return 2;
      case FairytailMatch.partial:
        return 1;
      case FairytailMatch.incorrect:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final columnCount = fairytailColumnLabels().length;
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
      color: kFairytailHeaderCellColor,
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
        color: kFairytailHeaderCellColor,
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
      FairytailMatch.correct => kFairytailCorrectColor,
      FairytailMatch.partial => kFairytailPartialColor,
      FairytailMatch.incorrect => kFairytailIncorrectColor,
    };
    final display = best.match == FairytailMatch.correct ? best.value : '?';

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

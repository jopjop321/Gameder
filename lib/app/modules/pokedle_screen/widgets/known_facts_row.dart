import 'package:flutter/material.dart';

import '../models/guess_result.dart';
import '../theme/pokedle_theme.dart';

class KnownFactsRow extends StatelessWidget {
  final List<GuessResult> guesses;

  const KnownFactsRow({super.key, required this.guesses});

  int _statusRank(CellStatus status) {
    switch (status) {
      case CellStatus.correct:
        return 2;
      case CellStatus.partial:
        return 1;
      case CellStatus.wrong:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(kColumnLabels.length, (i) {
        if (i == 0) return _buildPlaceholderCell();
        return _buildSummaryCell(i);
      }),
    );
  }

  Widget _buildPlaceholderCell() {
    return _cellShell(
      color: kCardColor,
      bordered: true,
      child: const Text(
        '?',
        style: TextStyle(
          color: Colors.white38,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSummaryCell(int columnIndex) {
    if (guesses.isEmpty) {
      return _cellShell(
        color: kCardColor,
        bordered: true,
        child: const Text('?',
            style: TextStyle(color: Colors.white38, fontSize: 18)),
      );
    }

    AttributeResult best = guesses.first.attributes[columnIndex];
    for (final g in guesses) {
      final attr = g.attributes[columnIndex];
      if (_statusRank(attr.status) > _statusRank(best.status)) {
        best = attr;
      }
    }

    final display = best.status == CellStatus.correct ? best.display : '?';

    return _cellShell(
      color: best.color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              display,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (best.arrow != ArrowDirection.none) ...[
            const SizedBox(width: 2),
            Icon(
              best.arrow == ArrowDirection.up
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: Colors.white,
              size: 14,
            ),
          ],
        ],
      ),
    );
  }

  Widget _cellShell({
    required Color color,
    required Widget child,
    bool bordered = false,
  }) {
    return Container(
      width: kCellWidth,
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: kCellHMargin),
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

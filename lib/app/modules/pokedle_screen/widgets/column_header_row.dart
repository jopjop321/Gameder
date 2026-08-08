import 'package:flutter/material.dart';

import '../theme/pokedle_theme.dart';

class ColumnHeaderRow extends StatelessWidget {
  const ColumnHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: kColumnLabels
          .map(
            (label) => Container(
              width: kCellWidth,
              margin: const EdgeInsets.symmetric(horizontal: kCellHMargin),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

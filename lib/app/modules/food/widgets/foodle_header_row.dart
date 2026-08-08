import 'package:flutter/material.dart';

import '../theme/foodle_theme.dart';

class FoodleHeaderRow extends StatelessWidget {
  final bool includeRegion;

  const FoodleHeaderRow({super.key, this.includeRegion = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: foodColumnLabels(includeRegion: includeRegion)
            .map(
              (label) => Container(
                width: 98,
                height: 64,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.all(6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kFoodHeaderCellColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

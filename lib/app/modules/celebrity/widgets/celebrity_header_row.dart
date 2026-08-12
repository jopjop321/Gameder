import 'package:flutter/material.dart';

import '../theme/celebrity_theme.dart';

class CelebrityHeaderRow extends StatelessWidget {
  final bool includeOccupation;
  final bool includeYoutuberFields;

  const CelebrityHeaderRow({
    super.key,
    this.includeOccupation = false,
    this.includeYoutuberFields = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: celebrityColumnLabels(
          includeOccupation: includeOccupation,
          includeYoutuberFields: includeYoutuberFields,
        )
            .map(
              (label) => Container(
                width: 98,
                height: 64,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.all(6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kCelebrityHeaderCellColor,
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

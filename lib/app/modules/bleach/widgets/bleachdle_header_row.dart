import 'package:flutter/material.dart';

import '../theme/bleachdle_theme.dart';

class BleachdleHeaderRow extends StatelessWidget {
  const BleachdleHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: bleachColumnLabels()
            .map(
              (label) => Container(
                width: 98,
                height: 64,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.all(6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kBleachHeaderCellColor,
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

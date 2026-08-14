import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/herodle_theme.dart';

class MhaErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const MhaErrorState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: kMhaIncorrectColor, size: 48),
            const SizedBox(height: 12),
            Text(
              'mha_notFoundTitle'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'mha_assetsMissingHint'.tr,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text('common_retry'.tr),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/placedle_theme.dart';

class PlaceErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const PlaceErrorState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: kPlaceIncorrectColor, size: 48),
            const SizedBox(height: 12),
            Text(
              'place_notFoundTitle'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'place_assetsMissingHint'.tr,
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

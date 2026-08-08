import 'package:flutter/material.dart';

import '../theme/foodle_theme.dart';

class FoodErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const FoodErrorState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: kFoodIncorrectColor, size: 48),
            const SizedBox(height: 12),
            const Text(
              'ไม่พบข้อมูลอาหาร',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'ตรวจสอบว่าประกาศ assets/data/food/food.json ไว้ใน pubspec.yaml แล้วหรือยัง',
              style: TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('ลองใหม่'),
            ),
          ],
        ),
      ),
    );
  }
}

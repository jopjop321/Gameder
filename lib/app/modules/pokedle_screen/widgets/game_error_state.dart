import 'package:flutter/material.dart';

import '../theme/pokedle_theme.dart';

class GameErrorState extends StatelessWidget {
  final String genFile;
  final VoidCallback onRetry;

  const GameErrorState({
    super.key,
    required this.genFile,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: kWrongColor, size: 48),
            const SizedBox(height: 12),
            const Text(
              'ไม่พบข้อมูล Pokémon',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'ตรวจสอบว่าประกาศ assets/data/$genFile.json '
              'ไว้ใน pubspec.yaml แล้วหรือยัง',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
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

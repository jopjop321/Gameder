import 'package:flutter/material.dart';

import '../theme/pokedle_theme.dart';

Future<bool> showSurrenderConfirmation(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: kCardColor,
      title: const Text(
        'ยอมแพ้?',
        style: TextStyle(color: Colors.white),
      ),
      content: const Text(
        'ต้องการยอมแพ้และดูเฉลยของรอบนี้ใช่ไหม',
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('เล่นต่อ'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: kWrongColor),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('ยอมแพ้'),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}

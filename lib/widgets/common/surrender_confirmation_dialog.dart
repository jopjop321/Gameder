import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> showSurrenderConfirmation(
  BuildContext context, {
  required Color cardColor,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: cardColor,
      title: Text(
        'pokedle_surrenderTitle'.tr,
        style: const TextStyle(color: Colors.white),
      ),
      content: Text(
        'pokedle_surrenderBody'.tr,
        style: const TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text('common_continuePlaying'.tr),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFE74C3C),
          ),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text('pokedle_surrenderTooltip'.tr),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}

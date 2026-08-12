import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/pokedle_theme.dart';

Future<bool> showSurrenderConfirmation(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: kCardColor,
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
          style: FilledButton.styleFrom(backgroundColor: kWrongColor),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text('pokedle_surrenderTooltip'.tr),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}

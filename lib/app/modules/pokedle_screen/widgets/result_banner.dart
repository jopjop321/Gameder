import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../controllers/pokemon.dart';
import '../theme/pokedle_theme.dart';

class ResultBanner extends StatelessWidget {
  final Pokemon answer;
  final bool won;
  final VoidCallback onRestart;

  const ResultBanner({
    super.key,
    required this.answer,
    required this.won,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: won
              ? [kCorrectColor.withOpacity(0.9), kAccentColor.withOpacity(0.9)]
              : [kWrongColor.withOpacity(0.9), kCardColor],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: answer.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  won ? 'You caught it!' : 'Out of guesses!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'The answer was ${answer.name} (${answer.nameTh})',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRestart,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Play again',
          ),
        ],
      ),
    );
  }
}

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/aot_character.dart';
import '../models/aot_guess_result.dart';
import '../theme/titandle_theme.dart';

class TitandleGuessRow extends StatefulWidget {
  final AotGuessResult result;
  final bool animate;

  const TitandleGuessRow({
    super.key,
    required this.result,
    required this.animate,
  });

  @override
  State<TitandleGuessRow> createState() => _TitandleGuessRowState();
}

class _TitandleGuessRowState extends State<TitandleGuessRow>
    with TickerProviderStateMixin {
  static const _staggerDelay = Duration(milliseconds: 180);
  static const _flipDuration = Duration(milliseconds: 400);
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _flips;

  @override
  void initState() {
    super.initState();
    final cellCount = widget.result.cells.length;
    _controllers = List.generate(
      cellCount,
      (_) => AnimationController(vsync: this, duration: _flipDuration),
    );
    _flips = _controllers
        .map(
          (controller) => Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          ),
        )
        .toList();

    if (widget.animate) {
      _playStaggered();
    } else {
      for (final controller in _controllers) {
        controller.value = 1;
      }
    }
  }

  Future<void> _playStaggered() async {
    for (final controller in _controllers) {
      if (!mounted) return;
      controller.forward();
      await Future<void>.delayed(_staggerDelay);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cells = widget.result.cells;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: List.generate(cells.length, (index) {
          return _TitandleFlipCell(
            animation: _flips[index],
            child: index == 0
                ? _TitandleNameCellContent(
                    character: widget.result.character,
                    color: _matchColor(cells[index].match),
                  )
                : _TitandleCellContent(
                    value: cells[index].value,
                    color: _matchColor(cells[index].match),
                  ),
          );
        }),
      ),
    );
  }

  Color _matchColor(AotMatch match) {
    switch (match) {
      case AotMatch.correct:
        return kAotCorrectColor;
      case AotMatch.partial:
        return kAotPartialColor;
      case AotMatch.incorrect:
        return kAotIncorrectColor;
    }
  }
}

class _TitandleFlipCell extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _TitandleFlipCell({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final progress = animation.value;
        final isFrontVisible = progress < 0.5;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0015)
            ..rotateY(progress * pi),
          child: isFrontVisible
              ? const _TitandleCellContent(
                  value: '',
                  color: kAotHeaderCellColor,
                )
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: child,
                ),
        );
      },
    );
  }
}

class _TitandleNameCellContent extends StatelessWidget {
  final AotCharacter character;
  final Color color;

  const _TitandleNameCellContent({required this.character, required this.color});

  @override
  Widget build(BuildContext context) {
    final imageUrl = character.imageUrl;
    return Container(
      width: 98,
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox(
                  width: 36,
                  height: 36,
                  child: Center(
                    child: SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.terrain_rounded,
                  color: Colors.white70,
                  size: 28,
                ),
              ),
            ),
          const SizedBox(height: 2),
          Text(
            character.displayName,
            textAlign: TextAlign.center,
            maxLines: imageUrl != null ? 1 : 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TitandleCellContent extends StatelessWidget {
  final String value;
  final Color color;

  const _TitandleCellContent({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 98,
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.all(6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

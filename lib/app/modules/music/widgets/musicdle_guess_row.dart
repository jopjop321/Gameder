import 'dart:math';

import 'package:flutter/material.dart';

import '../models/song_guess_result.dart';
import '../theme/musicdle_theme.dart';

class MusicdleGuessRow extends StatefulWidget {
  final SongGuessResult result;
  final bool animate;

  const MusicdleGuessRow({
    super.key,
    required this.result,
    required this.animate,
  });

  @override
  State<MusicdleGuessRow> createState() => _MusicdleGuessRowState();
}

class _MusicdleGuessRowState extends State<MusicdleGuessRow>
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
          return _MusicdleFlipCell(
            animation: _flips[index],
            child: _MusicdleCellContent(
              value: cells[index].value,
              color: _matchColor(cells[index].match),
            ),
          );
        }),
      ),
    );
  }

  Color _matchColor(SongMatch match) {
    switch (match) {
      case SongMatch.correct:
        return kMusicCorrectColor;
      case SongMatch.partial:
        return kMusicPartialColor;
      case SongMatch.incorrect:
        return kMusicIncorrectColor;
    }
  }
}

class _MusicdleFlipCell extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _MusicdleFlipCell({required this.animation, required this.child});

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
              ? const _MusicdleCellContent(value: '', color: kMusicHeaderCellColor)
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

class _MusicdleCellContent extends StatelessWidget {
  final String value;
  final Color color;

  const _MusicdleCellContent({required this.value, required this.color});

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

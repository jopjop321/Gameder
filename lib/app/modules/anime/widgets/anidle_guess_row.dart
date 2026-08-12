import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/anime.dart';
import '../models/anime_guess_result.dart';
import '../theme/anidle_theme.dart';

class AnidleGuessRow extends StatefulWidget {
  final AnimeGuessResult result;
  final bool animate;

  const AnidleGuessRow({
    super.key,
    required this.result,
    required this.animate,
  });

  @override
  State<AnidleGuessRow> createState() => _AnidleGuessRowState();
}

class _AnidleGuessRowState extends State<AnidleGuessRow>
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
          return _AnidleFlipCell(
            animation: _flips[index],
            child: index == 0
                ? _AnidleNameCellContent(
                    anime: widget.result.anime,
                    color: _matchColor(cells[index].match),
                  )
                : _AnidleCellContent(
                    value: cells[index].value,
                    color: _matchColor(cells[index].match),
                  ),
          );
        }),
      ),
    );
  }

  Color _matchColor(AnimeMatch match) {
    switch (match) {
      case AnimeMatch.correct:
        return kAnimeCorrectColor;
      case AnimeMatch.partial:
        return kAnimePartialColor;
      case AnimeMatch.incorrect:
        return kAnimeIncorrectColor;
    }
  }
}

class _AnidleFlipCell extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _AnidleFlipCell({required this.animation, required this.child});

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
              ? const _AnidleCellContent(value: '', color: kAnimeHeaderCellColor)
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

class _AnidleNameCellContent extends StatelessWidget {
  final Anime anime;
  final Color color;

  const _AnidleNameCellContent({required this.anime, required this.color});

  @override
  Widget build(BuildContext context) {
    final imageUrl = anime.imageUrl;
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
                errorWidget: (context, url, error) =>
                    const Icon(Icons.movie_filter_outlined, color: Colors.white70, size: 28),
              ),
            ),
          const SizedBox(height: 2),
          Text(
            anime.displayName,
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

class _AnidleCellContent extends StatelessWidget {
  final String value;
  final Color color;

  const _AnidleCellContent({required this.value, required this.color});

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

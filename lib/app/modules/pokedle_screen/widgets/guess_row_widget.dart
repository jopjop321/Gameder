import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../controllers/pokemon.dart';
import '../models/guess_result.dart';
import '../theme/pokedle_theme.dart';

class GuessRowWidget extends StatefulWidget {
  final GuessResult result;
  final bool animate;

  const GuessRowWidget({
    super.key,
    required this.result,
    required this.animate,
  });

  @override
  State<GuessRowWidget> createState() => _GuessRowWidgetState();
}

class _GuessRowWidgetState extends State<GuessRowWidget>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _flips;

  static const _staggerDelay = Duration(milliseconds: 180);
  static const _flipDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    final count = widget.result.attributes.length;
    _controllers = List.generate(
      count,
      (_) => AnimationController(vsync: this, duration: _flipDuration),
    );
    _flips = _controllers
        .map((c) => Tween<double>(begin: 0, end: 1)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeInOut)))
        .toList();

    if (widget.animate) {
      _playStaggered();
    } else {
      for (final c in _controllers) {
        c.value = 1;
      }
    }
  }

  Future<void> _playStaggered() async {
    for (var i = 0; i < _controllers.length; i++) {
      if (!mounted) return;
      _controllers[i].forward();
      await Future.delayed(_staggerDelay);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attrs = widget.result.attributes;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: List.generate(attrs.length, (i) {
          if (i == 0) {
            return _FlipCell(
              animation: _flips[i],
              color: attrs[i].color,
              child: _PokemonCellContent(pokemon: widget.result.pokemon),
            );
          }
          return _FlipCell(
            animation: _flips[i],
            color: attrs[i].color,
            child: _AttributeCellContent(attribute: attrs[i]),
          );
        }),
      ),
    );
  }
}

class _FlipCell extends StatelessWidget {
  final Animation<double> animation;
  final Color color;
  final Widget child;

  const _FlipCell({
    required this.animation,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kCellWidth,
      height: kCellWidth,
      margin: const EdgeInsets.symmetric(horizontal: kCellHMargin),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final t = animation.value;
          final showFront = t < 0.5;
          final angle = t * pi;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015)
              ..rotateY(angle),
            child: showFront
                ? _CellFace(color: kCardColor, child: const SizedBox.shrink())
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _CellFace(color: color, child: child),
                  ),
          );
        },
      ),
    );
  }
}

class _CellFace extends StatelessWidget {
  final Color color;
  final Widget child;

  const _CellFace({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black.withOpacity(0.2)),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      child: child,
    );
  }
}

class _PokemonCellContent extends StatelessWidget {
  final Pokemon pokemon;

  const _PokemonCellContent({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl: pokemon.imageUrl,
            width: 44,
            height: 44,
            fit: BoxFit.contain,
            placeholder: (context, url) => const SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            errorWidget: (context, url, error) =>
                const Icon(Icons.help_outline, color: Colors.white70),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          pokemon.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _AttributeCellContent extends StatelessWidget {
  final AttributeResult attribute;

  const _AttributeCellContent({required this.attribute});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            attribute.display,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (attribute.arrow != ArrowDirection.none) ...[
          const SizedBox(width: 2),
          Icon(
            attribute.arrow == ArrowDirection.up
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            color: Colors.white,
            size: 14,
          ),
        ],
      ],
    );
  }
}

import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../controllers/pokemon.dart';

// ─────────────────────────────────────────────────────────────────────────
// Constants & shared styling
// ─────────────────────────────────────────────────────────────────────────

const Color kBgColor = Color(0xFF1A1A2E);
const Color kCardColor = Color(0xFF232342);
const Color kCorrectColor = Color(0xFF2ECC71);
const Color kPartialColor = Color(0xFFE67E22);
const Color kWrongColor = Color(0xFFE74C3C);
const Color kAccentColor = Color(0xFF9D4EDD);

const List<String> kColumnLabels = [
  'Pokémon',
  'Type 1',
  'Type 2',
  'Evo Stage',
  'Fully Evolved',
  'Color',
  'Habitat',
  'Gen',
];

// Every column "slot" (cell width + its horizontal margins) must be
// identical between the header row and every guess row, since they all
// share a single horizontal scroll position.
const double kCellWidth = 84;
const double kCellHMargin = 2; // matches _FlipCell's margin on each side
const double kColumnSlotWidth = kCellWidth + kCellHMargin * 2;
// NOT const: List.length is a runtime getter, even on a const list, so this
// must be `final` rather than `const` or Dart throws const_eval_property_access.
final double kTableContentWidth = kColumnSlotWidth * kColumnLabels.length;

// ─────────────────────────────────────────────────────────────────────────
// Guess evaluation model
// ─────────────────────────────────────────────────────────────────────────

enum CellStatus { correct, partial, wrong }

/// Direction hint for numeric columns: answer is higher, lower, or equal.
enum ArrowDirection { up, down, none }

class AttributeResult {
  final CellStatus status;
  final String display;
  final ArrowDirection arrow;

  const AttributeResult({
    required this.status,
    required this.display,
    this.arrow = ArrowDirection.none,
  });

  Color get color {
    switch (status) {
      case CellStatus.correct:
        return kCorrectColor;
      case CellStatus.partial:
        return kPartialColor;
      case CellStatus.wrong:
        return kWrongColor;
    }
  }
}

class GuessResult {
  final Pokemon pokemon;
  final List<AttributeResult> attributes;
  final bool isWin;

  GuessResult({
    required this.pokemon,
    required this.attributes,
    required this.isWin,
  });

  /// Evaluates [guess] against [answer] and produces the eight-column result.
  factory GuessResult.evaluate(Pokemon guess, Pokemon answer) {
    final attrs = <AttributeResult>[
      // Column 0: Pokémon name/image itself.
      AttributeResult(
        status: guess.id == answer.id ? CellStatus.correct : CellStatus.wrong,
        display: guess.name,
      ),
      _evaluateType1(guess, answer),
      _evaluateType2(guess, answer),
      _evaluateNumeric(
        guessValue: guess.evolutionStage,
        answerValue: answer.evolutionStage,
        display: guess.evolutionStage.toString(),
      ),
      AttributeResult(
        status: guess.fullyEvolved == answer.fullyEvolved
            ? CellStatus.correct
            : CellStatus.wrong,
        display: guess.fullyEvolved ? 'Yes' : 'No',
      ),
      AttributeResult(
        status: guess.color.toLowerCase() == answer.color.toLowerCase()
            ? CellStatus.correct
            : CellStatus.wrong,
        display: guess.color,
      ),
      AttributeResult(
        status: guess.habitat.toLowerCase() == answer.habitat.toLowerCase()
            ? CellStatus.correct
            : CellStatus.wrong,
        display: guess.habitat,
      ),
      _evaluateNumeric(
        guessValue: guess.generation,
        answerValue: answer.generation,
        display: guess.generation.toString(),
      ),
    ];

    return GuessResult(
      pokemon: guess,
      attributes: attrs,
      isWin: guess.id == answer.id,
    );
  }

  static AttributeResult _evaluateType1(Pokemon guess, Pokemon answer) {
    if (guess.type1.toLowerCase() == answer.type1.toLowerCase()) {
      return AttributeResult(status: CellStatus.correct, display: guess.type1);
    }
    final answerTypes = answer.types.map((t) => t.toLowerCase()).toSet();
    if (answerTypes.contains(guess.type1.toLowerCase())) {
      return AttributeResult(status: CellStatus.partial, display: guess.type1);
    }
    return AttributeResult(status: CellStatus.wrong, display: guess.type1);
  }

  static AttributeResult _evaluateType2(Pokemon guess, Pokemon answer) {
    final gType2 = guess.type2;
    final aType2 = answer.type2;
    final display = gType2 ?? '—';

    if (gType2 == null && aType2 == null) {
      return AttributeResult(status: CellStatus.correct, display: display);
    }
    if (gType2 != null && aType2 != null &&
        gType2.toLowerCase() == aType2.toLowerCase()) {
      return AttributeResult(status: CellStatus.correct, display: display);
    }
    if (gType2 != null) {
      final answerTypes = answer.types.map((t) => t.toLowerCase()).toSet();
      if (answerTypes.contains(gType2.toLowerCase())) {
        return AttributeResult(status: CellStatus.partial, display: display);
      }
    }
    return AttributeResult(status: CellStatus.wrong, display: display);
  }

  static AttributeResult _evaluateNumeric({
    required int guessValue,
    required int answerValue,
    required String display,
  }) {
    final diff = answerValue - guessValue;
    final arrow = diff > 0
        ? ArrowDirection.up
        : diff < 0
            ? ArrowDirection.down
            : ArrowDirection.none;

    if (diff == 0) {
      return AttributeResult(
          status: CellStatus.correct, display: display, arrow: arrow);
    }
    if (diff.abs() == 1) {
      return AttributeResult(
          status: CellStatus.partial, display: display, arrow: arrow);
    }
    return AttributeResult(
        status: CellStatus.wrong, display: display, arrow: arrow);
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Game screen
// ─────────────────────────────────────────────────────────────────────────

class GameScreen extends StatefulWidget {
  /// 'gen1', 'gen2', or 'all'. Determines which asset JSON file(s) load.
  final String genFile;

  const GameScreen({super.key, required this.genFile});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

enum GameStatus { loading, playing, won, lost, error }

class _GameScreenState extends State<GameScreen> {
  List<Pokemon> _pokedex = [];
  Pokemon? _answer;
  GameStatus _status = GameStatus.loading;

  final List<GuessResult> _guesses = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _tableScrollController = ScrollController();
  List<Pokemon> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _loadPokedex();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _tableScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPokedex() async {
    final files = _resolveGenFiles(widget.genFile);
    final Map<int, Pokemon> byId = {};

    for (final file in files) {
      try {
        final raw = await rootBundle.loadString('assets/data/$file.json');
        final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
        for (final item in jsonList) {
          final p = Pokemon.fromJson(item as Map<String, dynamic>);
          byId[p.id] = p;
        }
      } catch (_) {
        // Skip gen files that don't exist as assets (relevant for 'all').
      }
    }

    final pokedex = byId.values.toList()..sort((a, b) => a.id.compareTo(b.id));
    if (pokedex.isEmpty) {
      // No Pokémon loaded at all — almost always a missing/misnamed asset
      // in pubspec.yaml, not a real "loss". Never fall through to code
      // that assumes _answer is non-null.
      setState(() => _status = GameStatus.error);
      return;
    }

    final answer = pokedex[Random().nextInt(pokedex.length)];
    setState(() {
      _pokedex = pokedex;
      _answer = answer;
      _status = GameStatus.playing;
    });
  }

  /// 'gen1' -> ['gen1'], 'gen2' -> ['gen2'], 'all' -> every known gen file.
  /// Missing files are silently skipped in [_loadPokedex].
  List<String> _resolveGenFiles(String genFile) {
    if (genFile == 'all') {
      return List.generate(9, (i) => 'gen${i + 1}');
    }
    return [genFile];
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query.trim().isEmpty) {
      setState(() => _suggestions = []);
      return;
    }
    final guessedIds = _guesses.map((g) => g.pokemon.id).toSet();
    setState(() {
      _suggestions = _pokedex
          .where((p) => !guessedIds.contains(p.id) && p.matchesQuery(query))
          .take(6)
          .toList();
    });
  }

  void _submitGuess(Pokemon guess) {
    if (_status != GameStatus.playing || _answer == null) return;

    final result = GuessResult.evaluate(guess, _answer!);
    setState(() {
      _guesses.insert(0, result);
      _searchController.clear();
      _suggestions = [];
      _searchFocusNode.unfocus();

      if (result.isWin) {
        _status = GameStatus.won;
      }
    });
  }

  void _restart() {
    setState(() {
      _guesses.clear();
      _searchController.clear();
      _suggestions = [];
      _status = GameStatus.loading;
    });
    _loadPokedex();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        title: const Text('Pokédle', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_status == GameStatus.playing)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  'ทายไปแล้ว ${_guesses.length} ครั้ง',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ),
        ],
      ),
      body: _status == GameStatus.loading
          ? const Center(
              child: CircularProgressIndicator(color: kAccentColor))
          : _status == GameStatus.error
              ? _buildErrorState()
              : SafeArea(
              child: Column(
                children: [
                  if (_status == GameStatus.won || _status == GameStatus.lost)
                    _ResultBanner(
                      answer: _answer!,
                      won: _status == GameStatus.won,
                      onRestart: _restart,
                    ),
                  const SizedBox(height: 8),
                  Expanded(
                    // Single horizontal scroller shared by the header AND
                    // every guess row below it, so they always move in sync.
                    child: SingleChildScrollView(
                      controller: _tableScrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        width: kTableContentWidth,
                        child: Column(
                          children: [
                            _ColumnHeaderRow(),
                            const Divider(color: Colors.white24, height: 1),
                            // Sticky summary of the best-known status per
                            // column across all guesses so far. Stays fixed
                            // above the guess list since only the ListView
                            // below it scrolls vertically.
                            _KnownFactsRow(guesses: _guesses),
                            const Divider(color: Colors.white12, height: 1),
                            Expanded(
                              child: _guesses.isEmpty
                                  ? Center(
                                      child: Text(
                                        'Make your first guess!',
                                        style: TextStyle(
                                            color: Colors.white
                                                .withOpacity(0.4)),
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      itemCount: _guesses.length,
                                      itemBuilder: (context, index) {
                                        // Most recent guess animates; older
                                        // ones show static.
                                        return GuessRowWidget(
                                          key: ValueKey(
                                              _guesses[index].pokemon.id),
                                          result: _guesses[index],
                                          animate: index == 0,
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_status == GameStatus.playing)
                    _SearchBar(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      suggestions: _suggestions,
                      onSelect: _submitGuess,
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildErrorState() {
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
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'ตรวจสอบว่าประกาศ assets/data/${widget.genFile}.json '
              'ไว้ใน pubspec.yaml แล้วหรือยัง',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _restart,
              icon: const Icon(Icons.refresh),
              label: const Text('ลองใหม่'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Column headers
// ─────────────────────────────────────────────────────────────────────────

class _ColumnHeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: kColumnLabels
          .map(
            (label) => Container(
              width: kCellWidth,
              margin: const EdgeInsets.symmetric(horizontal: kCellHMargin),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Sticky "known facts" summary row — shows the best-known status per column
// across every guess so far, so the player doesn't have to scroll to see
// what's already been narrowed down.
// ─────────────────────────────────────────────────────────────────────────

class _KnownFactsRow extends StatelessWidget {
  final List<GuessResult> guesses;

  const _KnownFactsRow({required this.guesses});

  int _statusRank(CellStatus status) {
    switch (status) {
      case CellStatus.correct:
        return 2;
      case CellStatus.partial:
        return 1;
      case CellStatus.wrong:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(kColumnLabels.length, (i) {
        // Column 0 is the Pokémon itself — never summarized, always "?"
        // until the player wins, per design.
        if (i == 0) return _buildPlaceholderCell();
        return _buildSummaryCell(i);
      }),
    );
  }

  Widget _buildPlaceholderCell() {
    return _cellShell(
      color: kCardColor,
      bordered: true,
      child: const Text(
        '?',
        style: TextStyle(
          color: Colors.white38,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSummaryCell(int columnIndex) {
    if (guesses.isEmpty) {
      return _cellShell(
        color: kCardColor,
        bordered: true,
        child: const Text('?',
            style: TextStyle(color: Colors.white38, fontSize: 18)),
      );
    }

    // Pick the best (most informative) result seen for this column across
    // every guess: an exact match beats a partial hint beats a miss.
    AttributeResult best = guesses.first.attributes[columnIndex];
    for (final g in guesses) {
      final attr = g.attributes[columnIndex];
      if (_statusRank(attr.status) > _statusRank(best.status)) {
        best = attr;
      }
    }

    final display = best.status == CellStatus.correct ? best.display : '?';

    return _cellShell(
      color: best.color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              display,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (best.arrow != ArrowDirection.none) ...[
            const SizedBox(width: 2),
            Icon(
              best.arrow == ArrowDirection.up
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: Colors.white,
              size: 14,
            ),
          ],
        ],
      ),
    );
  }

  Widget _cellShell({
    required Color color,
    required Widget child,
    bool bordered = false,
  }) {
    return Container(
      width: kCellWidth,
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: kCellHMargin),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: bordered ? Border.all(color: Colors.white24) : null,
      ),
      child: child,
    );
  }
}

class GuessRowWidget extends StatefulWidget {
  final GuessResult result;
  final bool animate;

  const GuessRowWidget({super.key, required this.result, required this.animate});

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
              child: _PokemonCellContent(
                pokemon: widget.result.pokemon,
              ),
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
          // First half of the flip shows the face-down card; second half
          // reveals the colored, resolved cell.
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
          pokemon.name,
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

// ─────────────────────────────────────────────────────────────────────────
// Search bar with autocomplete dropdown
// ─────────────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<Pokemon> suggestions;
  final ValueChanged<Pokemon> onSelect;

  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.suggestions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (suggestions.isNotEmpty)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final p = suggestions[index];
                    return ListTile(
                      dense: true,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: p.imageUrl,
                          width: 32,
                          height: 32,
                          fit: BoxFit.contain,
                          errorWidget: (c, u, e) =>
                              const Icon(Icons.catching_pokemon, size: 20),
                        ),
                      ),
                      title: Text(p.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        '${p.nameTh} · ${p.romajiTh} · ${p.romajiEn}',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12),
                      ),
                      onTap: () => onSelect(p),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kBgColor,
                  hintText: 'Guess a Pokémon...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Win / loss banner
// ─────────────────────────────────────────────────────────────────────────

class _ResultBanner extends StatelessWidget {
  final Pokemon answer;
  final bool won;
  final VoidCallback onRestart;

  const _ResultBanner({
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
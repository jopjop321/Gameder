import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/pokemon.dart';
import '../models/game_status.dart';
import '../models/guess_result.dart';
import '../services/pokedex_service.dart';
import '../theme/pokedle_theme.dart';
import '../widgets/column_header_row.dart';
import '../widgets/game_error_state.dart';
import '../widgets/guess_row_widget.dart';
import '../widgets/known_facts_row.dart';
import '../widgets/pokedex_dialog.dart';
import '../widgets/pokedle_search_bar.dart';
import '../widgets/result_banner.dart';
import '../widgets/surrender_confirmation_dialog.dart';

class GameScreen extends StatefulWidget {
  /// 'gen1', 'gen2', or 'all'. Determines which asset JSON file(s) load.
  final String genFile;

  const GameScreen({super.key, required this.genFile});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

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
    final pokedex = await PokedexService.loadPokedex(widget.genFile);
    if (pokedex.isEmpty) {
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

  Future<void> _openPokedex() async {
    final selected = await showPokedexDialog(context, _pokedex);
    if (!mounted || selected == null) return;
    setState(() => _searchController.text = selected.displayName);
    _searchFocusNode.requestFocus();
  }

  Future<void> _confirmSurrender() async {
    if (_status != GameStatus.playing || _answer == null) return;

    final shouldSurrender = await showSurrenderConfirmation(context);
    if (!mounted || !shouldSurrender) return;
    setState(() {
      _status = GameStatus.lost;
      _searchController.clear();
      _suggestions = [];
      _searchFocusNode.unfocus();
    });
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
          if (_pokedex.isNotEmpty)
            IconButton(
              tooltip: 'Pokédex',
              onPressed: () => _openPokedex(),
              icon: const Icon(Icons.menu_book_rounded),
            ),
          if (_status == GameStatus.playing)
            IconButton(
              tooltip: 'pokedle_surrenderTooltip'.tr,
              onPressed: _confirmSurrender,
              icon: const Icon(Icons.flag_outlined),
            ),
          if (_status == GameStatus.playing)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  'pokedle_guessCount'.trParams({'count': '${_guesses.length}'}),
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ),
        ],
      ),
      body: _status == GameStatus.loading
          ? const Center(
              child: CircularProgressIndicator(color: kAccentColor),
            )
          : _status == GameStatus.error
              ? GameErrorState(genFile: widget.genFile, onRetry: _restart)
              : SafeArea(
                  child: Column(
                    children: [
                      if (_status == GameStatus.won ||
                          _status == GameStatus.lost)
                        ResultBanner(
                          answer: _answer!,
                          won: _status == GameStatus.won,
                          onRestart: _restart,
                        ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _tableScrollController,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SizedBox(
                            width: kTableContentWidth,
                            child: Column(
                              children: [
                                const ColumnHeaderRow(),
                                const Divider(color: Colors.white24, height: 1),
                                KnownFactsRow(guesses: _guesses),
                                const Divider(color: Colors.white12, height: 1),
                                Expanded(
                                  child: _guesses.isEmpty
                                      ? Center(
                                          child: Text(
                                            'Make your first guess!',
                                            style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.4),
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          itemCount: _guesses.length,
                                          itemBuilder: (context, index) {
                                            return GuessRowWidget(
                                              key: ValueKey(
                                                _guesses[index].pokemon.id,
                                              ),
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
                        PokedleSearchBar(
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
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gameder/widgets/common/surrender_confirmation_dialog.dart';

import '../models/game_guess_result.dart';
import '../models/game_load_status.dart';
import '../models/video_game.dart';
import '../services/game_service.dart';
import '../theme/gamedle_theme.dart';
import '../widgets/game_dex_dialog.dart';
import '../widgets/game_error_state.dart';
import '../widgets/gamedle_guess_row.dart';
import '../widgets/gamedle_header_row.dart';
import '../widgets/gamedle_known_facts_row.dart';

class GamedleScreen extends StatefulWidget {
  final String platformId;
  final String title;

  const GamedleScreen({
    super.key,
    required this.platformId,
    required this.title,
  });

  @override
  State<GamedleScreen> createState() => _GamedleScreenState();
}

class _GamedleScreenState extends State<GamedleScreen> {
  final _random = Random();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _tableScrollController = ScrollController();
  GameLoadStatus _status = GameLoadStatus.loading;
  List<VideoGame> _availableGames = [];
  VideoGame? _answer;
  final List<GameGuessResult> _guesses = [];
  List<VideoGame> _suggestions = [];
  bool _isAnswerRevealed = false;
  bool _hasWon = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_updateSuggestions);
    _loadAndStartGame();
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_updateSuggestions)
      ..dispose();
    _searchFocusNode.dispose();
    _tableScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAndStartGame() async {
    setState(() => _status = GameLoadStatus.loading);

    final platformGames = await GameService.loadGames(widget.platformId);

    if (!mounted) return;
    if (platformGames.isEmpty) {
      setState(() => _status = GameLoadStatus.error);
      return;
    }

    setState(() {
      _availableGames = platformGames;
      _answer = platformGames[_random.nextInt(platformGames.length)];
      _guesses.clear();
      _suggestions = [];
      _isAnswerRevealed = false;
      _hasWon = false;
      _status = GameLoadStatus.ready;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchFocusNode.requestFocus();
    });
  }

  void _restart() {
    setState(() {
      _answer = _availableGames[_random.nextInt(_availableGames.length)];
      _guesses.clear();
      _suggestions = [];
      _isAnswerRevealed = false;
      _hasWon = false;
    });
  }

  void _updateSuggestions() {
    final query = _searchController.text;
    if (query.trim().isEmpty || _isAnswerRevealed || _hasWon) {
      setState(() => _suggestions = []);
      return;
    }

    final guessedNames = _guesses.map((result) => result.game.name).toSet();
    setState(() {
      _suggestions = _availableGames
          .where(
            (game) => !guessedNames.contains(game.name) && game.matchesQuery(query),
          )
          .toList();
    });
  }

  void _submitGuess(VideoGame game) {
    final alreadyGuessed = _guesses.any((result) => result.game.name == game.name);
    if (_status != GameLoadStatus.ready || _isAnswerRevealed || _hasWon || alreadyGuessed) {
      return;
    }

    final result = GameGuessResult.evaluate(game, _answer!);
    setState(() {
      _guesses.insert(0, result);
      _hasWon = result.isWin;
      _suggestions = [];
      _searchController.clear();
    });

    _scrollToLatestGuess();
    if (!_hasWon) _searchFocusNode.requestFocus();
  }

  void _scrollToLatestGuess() {
    if (!_tableScrollController.hasClients) return;

    _tableScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _revealAnswer() => setState(() => _isAnswerRevealed = true);

  Future<void> _confirmSurrender() async {
    if (_status != GameLoadStatus.ready || _isAnswerRevealed || _hasWon) return;
    final shouldSurrender = await showSurrenderConfirmation(
      context,
      cardColor: kGameHeaderCellColor,
    );
    if (!mounted || !shouldSurrender) return;
    _revealAnswer();
  }

  Future<void> _openGameDex() async {
    final selected = await showGameDexDialog(context, _availableGames);
    if (!mounted || selected == null) return;
    setState(() => _searchController.text = selected.name);
    _searchFocusNode.requestFocus();
  }

  void _submitFirstSuggestion(String _) {
    if (_suggestions.length == 1) _submitGuess(_suggestions.single);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGameBgColor,
      appBar: AppBar(
        title: Text('Gamedle: ${widget.title}'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_status == GameLoadStatus.ready)
            IconButton(
              onPressed: _openGameDex,
              icon: const Icon(Icons.menu_book_rounded),
              tooltip: 'game_dexTooltip'.tr,
            ),
          if (_status == GameLoadStatus.ready && !_isAnswerRevealed && !_hasWon)
            IconButton(
              tooltip: 'pokedle_surrenderTooltip'.tr,
              onPressed: _confirmSurrender,
              icon: const Icon(Icons.flag_outlined),
            ),
          if (_status == GameLoadStatus.ready && !_isAnswerRevealed && !_hasWon)
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
      body: SafeArea(
        child: _status == GameLoadStatus.loading
            ? const Center(
                child: CircularProgressIndicator(color: kGameAccentColor),
              )
            : _status == GameLoadStatus.error
                ? GameErrorState(onRetry: _loadAndStartGame)
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Text(
                          'common_unlimitedGuesses'.tr,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      Expanded(child: _buildGuessTable()),
                      if (_isAnswerRevealed || _hasWon) _buildAnswerBanner(),
                      _buildSearchArea(),
                    ],
                  ),
      ),
    );
  }

  Widget _buildGuessTable() {
    return SingleChildScrollView(
      controller: _tableScrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GamedleHeaderRow(),
            GamedleKnownFactsRow(guesses: _guesses),
            ..._guesses.asMap().entries.map(
                  (entry) => GamedleGuessRow(
                    key: ValueKey(entry.value.game.name),
                    result: entry.value,
                    animate: entry.key == 0,
                  ),
                ),
            if (_guesses.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: SizedBox(
                  width: 728,
                  child: Text(
                    'game_typeToStart'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kGameHeaderCellColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _hasWon
                  ? 'common_correctAnswerIs'.trParams({'name': _answer!.name})
                  : 'common_answerIs'.trParams({'name': _answer!.name}),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _searchController.clear();
              _restart();
            },
            child: Text('common_restart'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchArea() {
    return Container(
      color: kGamePanelColor,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_suggestions.isNotEmpty)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final game = _suggestions[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        game.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${game.developer} · ${game.genre}',
                        style: const TextStyle(color: Colors.white60),
                      ),
                      onTap: () => _submitGuess(game),
                    );
                  },
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    enabled: !_isAnswerRevealed && !_hasWon,
                    onSubmitted: _submitFirstSuggestion,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'game_inputHint'.tr,
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      filled: true,
                      fillColor: kGameBgColor,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

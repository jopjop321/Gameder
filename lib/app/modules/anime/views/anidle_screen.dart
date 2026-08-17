import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gameder/widgets/common/surrender_confirmation_dialog.dart';

import '../models/anime.dart';
import '../models/anime_guess_result.dart';
import '../models/anime_load_status.dart';
import '../services/anime_service.dart';
import '../theme/anidle_theme.dart';
import '../widgets/anime_dex_dialog.dart';
import '../widgets/anime_error_state.dart';
import '../widgets/anidle_guess_row.dart';
import '../widgets/anidle_header_row.dart';
import '../widgets/anidle_known_facts_row.dart';

class AnidleScreen extends StatefulWidget {
  final String difficultyId;
  final String title;

  const AnidleScreen({super.key, required this.difficultyId, required this.title});

  @override
  State<AnidleScreen> createState() => _AnidleScreenState();
}

class _AnidleScreenState extends State<AnidleScreen> {
  final _random = Random();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _tableScrollController = ScrollController();
  AnimeLoadStatus _status = AnimeLoadStatus.loading;
  List<Anime> _availableAnimes = [];
  Anime? _answer;
  final List<AnimeGuessResult> _guesses = [];
  List<Anime> _suggestions = [];
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
    setState(() => _status = AnimeLoadStatus.loading);

    final animes = await AnimeService.loadAnimes(widget.difficultyId);

    if (!mounted) return;
    if (animes.isEmpty) {
      setState(() => _status = AnimeLoadStatus.error);
      return;
    }

    setState(() {
      _availableAnimes = animes;
      _answer = animes[_random.nextInt(animes.length)];
      _guesses.clear();
      _suggestions = [];
      _isAnswerRevealed = false;
      _hasWon = false;
      _status = AnimeLoadStatus.ready;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchFocusNode.requestFocus();
    });
  }

  void _restart() {
    setState(() {
      _answer = _availableAnimes[_random.nextInt(_availableAnimes.length)];
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

    final guessedNames = _guesses.map((result) => result.anime.name).toSet();
    setState(() {
      _suggestions = _availableAnimes
          .where(
            (anime) => !guessedNames.contains(anime.name) && anime.matchesQuery(query),
          )
          .toList();
    });
  }

  void _submitGuess(Anime anime) {
    final alreadyGuessed = _guesses.any((result) => result.anime.name == anime.name);
    if (_status != AnimeLoadStatus.ready || _isAnswerRevealed || _hasWon || alreadyGuessed) {
      return;
    }

    final result = AnimeGuessResult.evaluate(anime, _answer!);
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
    if (_status != AnimeLoadStatus.ready || _isAnswerRevealed || _hasWon) return;
    final shouldSurrender = await showSurrenderConfirmation(
      context,
      cardColor: kAnimeHeaderCellColor,
    );
    if (!mounted || !shouldSurrender) return;
    _revealAnswer();
  }

  Future<void> _openAnimeDex() async {
    final selected = await showAnimeDexDialog(context, _availableAnimes);
    if (!mounted || selected == null) return;
    setState(() => _searchController.text = selected.displayName);
    _searchFocusNode.requestFocus();
  }

  void _submitFirstSuggestion(String _) {
    if (_suggestions.length == 1) _submitGuess(_suggestions.single);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAnimeBgColor,
      appBar: AppBar(
        title: Text('Anidle: ${widget.title}'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_status == AnimeLoadStatus.ready)
            IconButton(
              onPressed: _openAnimeDex,
              icon: const Icon(Icons.menu_book_rounded),
              tooltip: 'anime_dexTooltip'.tr,
            ),
          if (_status == AnimeLoadStatus.ready && !_isAnswerRevealed && !_hasWon)
            IconButton(
              tooltip: 'pokedle_surrenderTooltip'.tr,
              onPressed: _confirmSurrender,
              icon: const Icon(Icons.flag_outlined),
            ),
          if (_status == AnimeLoadStatus.ready && !_isAnswerRevealed && !_hasWon)
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
        child: _status == AnimeLoadStatus.loading
            ? const Center(
                child: CircularProgressIndicator(color: kAnimeAccentColor),
              )
            : _status == AnimeLoadStatus.error
                ? AnimeErrorState(onRetry: _loadAndStartGame)
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
            const AnidleHeaderRow(),
            AnidleKnownFactsRow(guesses: _guesses),
            ..._guesses.asMap().entries.map(
                  (entry) => AnidleGuessRow(
                    key: ValueKey(entry.value.anime.name),
                    result: entry.value,
                    animate: entry.key == 0,
                  ),
                ),
            if (_guesses.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: SizedBox(
                  width: 830,
                  child: Text(
                    'anime_typeToStart'.tr,
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
        color: kAnimeHeaderCellColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _hasWon
                  ? 'common_correctAnswerIs'
                      .trParams({'name': _answer!.displayName})
                  : 'common_answerIs'.trParams({'name': _answer!.displayName}),
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
      color: kAnimePanelColor,
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
                    final anime = _suggestions[index];
                    return ListTile(
                      dense: true,
                      leading: anime.imageUrl == null
                          ? null
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CachedNetworkImage(
                                imageUrl: anime.imageUrl!,
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                                errorWidget: (c, u, e) => const Icon(
                                  Icons.movie_filter_outlined,
                                  size: 20,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                      title: Text(
                        anime.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${anime.studio} · ${anime.format}',
                        style: const TextStyle(color: Colors.white60),
                      ),
                      onTap: () => _submitGuess(anime),
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
                      hintText: 'anime_inputHint'.tr,
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      filled: true,
                      fillColor: kAnimeBgColor,
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

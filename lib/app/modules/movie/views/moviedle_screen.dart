import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gameder/widgets/common/surrender_confirmation_dialog.dart';

import '../models/movie.dart';
import '../models/movie_guess_result.dart';
import '../models/movie_load_status.dart';
import '../services/movie_service.dart';
import '../theme/moviedle_theme.dart';
import '../widgets/movie_dex_dialog.dart';
import '../widgets/movie_error_state.dart';
import '../widgets/moviedle_guess_row.dart';
import '../widgets/moviedle_header_row.dart';
import '../widgets/moviedle_known_facts_row.dart';

class MoviedleScreen extends StatefulWidget {
  final String collectionId;
  final String title;

  const MoviedleScreen({
    super.key,
    required this.collectionId,
    required this.title,
  });

  @override
  State<MoviedleScreen> createState() => _MoviedleScreenState();
}

class _MoviedleScreenState extends State<MoviedleScreen> {
  final _random = Random();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _tableScrollController = ScrollController();
  MovieLoadStatus _status = MovieLoadStatus.loading;
  List<Movie> _availableMovies = [];
  Movie? _answer;
  final List<MovieGuessResult> _guesses = [];
  List<Movie> _suggestions = [];
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
    setState(() => _status = MovieLoadStatus.loading);

    final collectionMovies = await MovieService.loadMovies(widget.collectionId);

    if (!mounted) return;
    if (collectionMovies.isEmpty) {
      setState(() => _status = MovieLoadStatus.error);
      return;
    }

    setState(() {
      _availableMovies = collectionMovies;
      _answer = collectionMovies[_random.nextInt(collectionMovies.length)];
      _guesses.clear();
      _suggestions = [];
      _isAnswerRevealed = false;
      _hasWon = false;
      _status = MovieLoadStatus.ready;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchFocusNode.requestFocus();
    });
  }

  void _restart() {
    setState(() {
      _answer = _availableMovies[_random.nextInt(_availableMovies.length)];
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

    final guessedNames = _guesses.map((result) => result.movie.name).toSet();
    setState(() {
      _suggestions = _availableMovies
          .where(
            (movie) => !guessedNames.contains(movie.name) && movie.matchesQuery(query),
          )
          .toList();
    });
  }

  void _submitGuess(Movie movie) {
    final alreadyGuessed = _guesses.any((result) => result.movie.name == movie.name);
    if (_status != MovieLoadStatus.ready || _isAnswerRevealed || _hasWon || alreadyGuessed) {
      return;
    }

    final result = MovieGuessResult.evaluate(movie, _answer!);
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
    if (_status != MovieLoadStatus.ready || _isAnswerRevealed || _hasWon) return;
    final shouldSurrender = await showSurrenderConfirmation(
      context,
      cardColor: kMovieHeaderCellColor,
    );
    if (!mounted || !shouldSurrender) return;
    _revealAnswer();
  }

  Future<void> _openMovieDex() async {
    final selected = await showMovieDexDialog(context, _availableMovies);
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
      backgroundColor: kMovieBgColor,
      appBar: AppBar(
        title: Text('Moviedle: ${widget.title}'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_status == MovieLoadStatus.ready)
            IconButton(
              onPressed: _openMovieDex,
              icon: const Icon(Icons.menu_book_rounded),
              tooltip: 'movie_dexTooltip'.tr,
            ),
          if (_status == MovieLoadStatus.ready && !_isAnswerRevealed && !_hasWon)
            IconButton(
              tooltip: 'pokedle_surrenderTooltip'.tr,
              onPressed: _confirmSurrender,
              icon: const Icon(Icons.flag_outlined),
            ),
          if (_status == MovieLoadStatus.ready && !_isAnswerRevealed && !_hasWon)
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
        child: _status == MovieLoadStatus.loading
            ? const Center(
                child: CircularProgressIndicator(color: kMovieAccentColor),
              )
            : _status == MovieLoadStatus.error
                ? MovieErrorState(onRetry: _loadAndStartGame)
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
            const MoviedleHeaderRow(),
            MoviedleKnownFactsRow(guesses: _guesses),
            ..._guesses.asMap().entries.map(
                  (entry) => MoviedleGuessRow(
                    key: ValueKey(entry.value.movie.name),
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
                    'movie_typeToStart'.tr,
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
        color: kMovieHeaderCellColor,
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
      color: kMoviePanelColor,
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
                    final movie = _suggestions[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        movie.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${movie.director} · ${movie.genre}',
                        style: const TextStyle(color: Colors.white60),
                      ),
                      onTap: () => _submitGuess(movie),
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
                      hintText: 'movie_inputHint'.tr,
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      filled: true,
                      fillColor: kMovieBgColor,
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

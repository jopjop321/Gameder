import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gameder/widgets/common/surrender_confirmation_dialog.dart';

import '../models/place.dart';
import '../models/place_guess_result.dart';
import '../models/place_load_status.dart';
import '../services/place_service.dart';
import '../theme/placedle_theme.dart';
import '../widgets/place_dex_dialog.dart';
import '../widgets/place_error_state.dart';
import '../widgets/placedle_guess_row.dart';
import '../widgets/placedle_header_row.dart';
import '../widgets/placedle_known_facts_row.dart';

class PlacedleScreen extends StatefulWidget {
  final String regionId;
  final String title;

  const PlacedleScreen({super.key, required this.regionId, required this.title});

  @override
  State<PlacedleScreen> createState() => _PlacedleScreenState();
}

class _PlacedleScreenState extends State<PlacedleScreen> {
  final _random = Random();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _tableScrollController = ScrollController();
  PlaceLoadStatus _status = PlaceLoadStatus.loading;
  List<Place> _availablePlaces = [];
  Place? _answer;
  final List<PlaceGuessResult> _guesses = [];
  List<Place> _suggestions = [];
  bool _isAnswerRevealed = false;
  bool _hasWon = false;

  bool get _includeRegion => widget.regionId == 'thailand';

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
    setState(() => _status = PlaceLoadStatus.loading);

    final regionPlaces = await PlaceService.loadPlaces(widget.regionId);

    if (!mounted) return;
    if (regionPlaces.isEmpty) {
      setState(() => _status = PlaceLoadStatus.error);
      return;
    }

    setState(() {
      _availablePlaces = regionPlaces;
      _answer = regionPlaces[_random.nextInt(regionPlaces.length)];
      _guesses.clear();
      _suggestions = [];
      _isAnswerRevealed = false;
      _hasWon = false;
      _status = PlaceLoadStatus.ready;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchFocusNode.requestFocus();
    });
  }

  void _restart() {
    setState(() {
      _answer = _availablePlaces[_random.nextInt(_availablePlaces.length)];
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

    final guessedNames = _guesses.map((result) => result.place.name).toSet();
    setState(() {
      _suggestions = _availablePlaces
          .where(
            (place) => !guessedNames.contains(place.name) && place.matchesQuery(query),
          )
          .toList();
    });
  }

  void _submitGuess(Place place) {
    final alreadyGuessed = _guesses.any((result) => result.place.name == place.name);
    if (_status != PlaceLoadStatus.ready || _isAnswerRevealed || _hasWon || alreadyGuessed) {
      return;
    }

    final result = PlaceGuessResult.evaluate(
      place,
      _answer!,
      includeRegion: _includeRegion,
    );
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
    if (_status != PlaceLoadStatus.ready || _isAnswerRevealed || _hasWon) return;
    final shouldSurrender = await showSurrenderConfirmation(
      context,
      cardColor: kPlaceHeaderCellColor,
    );
    if (!mounted || !shouldSurrender) return;
    _revealAnswer();
  }

  Future<void> _openPlaceDex() async {
    final selected = await showPlaceDexDialog(
      context,
      _availablePlaces,
      groupByRegion: _includeRegion,
    );
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
      backgroundColor: kPlaceBgColor,
      appBar: AppBar(
        title: Text('Placedle: ${widget.title}'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_status == PlaceLoadStatus.ready)
            IconButton(
              onPressed: _openPlaceDex,
              icon: const Icon(Icons.menu_book_rounded),
              tooltip: 'place_dexTooltip'.tr,
            ),
          if (_status == PlaceLoadStatus.ready && !_isAnswerRevealed && !_hasWon)
            IconButton(
              tooltip: 'pokedle_surrenderTooltip'.tr,
              onPressed: _confirmSurrender,
              icon: const Icon(Icons.flag_outlined),
            ),
          if (_status == PlaceLoadStatus.ready && !_isAnswerRevealed && !_hasWon)
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
        child: _status == PlaceLoadStatus.loading
            ? const Center(
                child: CircularProgressIndicator(color: kPlaceAccentColor),
              )
            : _status == PlaceLoadStatus.error
                ? PlaceErrorState(onRetry: _loadAndStartGame)
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
            PlacedleHeaderRow(includeRegion: _includeRegion),
            PlacedleKnownFactsRow(guesses: _guesses, includeRegion: _includeRegion),
            ..._guesses.asMap().entries.map(
                  (entry) => PlacedleGuessRow(
                    key: ValueKey(entry.value.place.name),
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
                    'place_typeToStart'.tr,
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
        color: kPlaceHeaderCellColor,
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
      color: kPlacePanelColor,
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
                    final place = _suggestions[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        place.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${place.displayCountry} · ${place.displayPlaceType}',
                        style: const TextStyle(color: Colors.white60),
                      ),
                      onTap: () => _submitGuess(place),
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
                      hintText: 'place_inputHint'.tr,
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      filled: true,
                      fillColor: kPlaceBgColor,
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

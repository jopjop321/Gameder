import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gameder/widgets/common/surrender_confirmation_dialog.dart';

import '../models/food.dart';
import '../models/food_guess_result.dart';
import '../models/food_load_status.dart';
import '../services/food_service.dart';
import '../theme/foodle_theme.dart';
import '../widgets/food_dex_dialog.dart';
import '../widgets/food_error_state.dart';
import '../widgets/foodle_guess_row.dart';
import '../widgets/foodle_header_row.dart';
import '../widgets/foodle_known_facts_row.dart';

class FoodleScreen extends StatefulWidget {
  final String regionId;
  final String title;

  const FoodleScreen({super.key, required this.regionId, required this.title});

  @override
  State<FoodleScreen> createState() => _FoodleScreenState();
}

class _FoodleScreenState extends State<FoodleScreen> {
  final _random = Random();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _tableScrollController = ScrollController();
  FoodLoadStatus _status = FoodLoadStatus.loading;
  List<Food> _availableFoods = [];
  Food? _answer;
  final List<FoodGuessResult> _guesses = [];
  List<Food> _suggestions = [];
  bool _isAnswerRevealed = false;
  bool _hasWon = false;

  bool get _includeRegion => widget.regionId == 'thai';

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
    setState(() => _status = FoodLoadStatus.loading);

    final regionFoods = await FoodService.loadFoods(widget.regionId);

    if (!mounted) return;
    if (regionFoods.isEmpty) {
      setState(() => _status = FoodLoadStatus.error);
      return;
    }

    setState(() {
      _availableFoods = regionFoods;
      _answer = regionFoods[_random.nextInt(regionFoods.length)];
      _guesses.clear();
      _suggestions = [];
      _isAnswerRevealed = false;
      _hasWon = false;
      _status = FoodLoadStatus.ready;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchFocusNode.requestFocus();
    });
  }

  void _restart() {
    setState(() {
      _answer = _availableFoods[_random.nextInt(_availableFoods.length)];
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

    final guessedNames = _guesses.map((result) => result.food.name).toSet();
    setState(() {
      _suggestions = _availableFoods
          .where(
            (food) => !guessedNames.contains(food.name) && food.matchesQuery(query),
          )
          .toList();
    });
  }

  void _submitGuess(Food food) {
    final alreadyGuessed = _guesses.any((result) => result.food.name == food.name);
    if (_status != FoodLoadStatus.ready || _isAnswerRevealed || _hasWon || alreadyGuessed) {
      return;
    }

    final result = FoodGuessResult.evaluate(
      food,
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
    if (_status != FoodLoadStatus.ready || _isAnswerRevealed || _hasWon) return;
    final shouldSurrender = await showSurrenderConfirmation(
      context,
      cardColor: kFoodHeaderCellColor,
    );
    if (!mounted || !shouldSurrender) return;
    _revealAnswer();
  }

  Future<void> _openFoodDex() async {
    final selected = await showFoodDexDialog(context, _availableFoods);
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
      backgroundColor: kFoodBgColor,
      appBar: AppBar(
        title: Text('Foodle: ${widget.title}'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_status == FoodLoadStatus.ready)
            IconButton(
              onPressed: _openFoodDex,
              icon: const Icon(Icons.menu_book_rounded),
              tooltip: 'food_dexTooltip'.tr,
            ),
          if (_status == FoodLoadStatus.ready && !_isAnswerRevealed && !_hasWon)
            IconButton(
              tooltip: 'pokedle_surrenderTooltip'.tr,
              onPressed: _confirmSurrender,
              icon: const Icon(Icons.flag_outlined),
            ),
          if (_status == FoodLoadStatus.ready && !_isAnswerRevealed && !_hasWon)
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
        child: _status == FoodLoadStatus.loading
            ? const Center(
                child: CircularProgressIndicator(color: kFoodAccentColor),
              )
            : _status == FoodLoadStatus.error
                ? FoodErrorState(onRetry: _loadAndStartGame)
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
            FoodleHeaderRow(includeRegion: _includeRegion),
            FoodleKnownFactsRow(guesses: _guesses, includeRegion: _includeRegion),
            ..._guesses.asMap().entries.map(
                  (entry) => FoodleGuessRow(
                    key: ValueKey(entry.value.food.name),
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
                    'food_typeToStart'.tr,
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
        color: kFoodHeaderCellColor,
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
      color: kFoodPanelColor,
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
                    final food = _suggestions[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        food.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${food.displayCountry} · ${food.displayDishType}',
                        style: const TextStyle(color: Colors.white60),
                      ),
                      onTap: () => _submitGuess(food),
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
                      hintText: 'food_inputHint'.tr,
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      filled: true,
                      fillColor: kFoodBgColor,
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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/car.dart';
import '../models/car_guess_result.dart';
import '../models/car_load_status.dart';
import '../services/car_service.dart';
import '../theme/cardle_theme.dart';
import '../widgets/car_dex_dialog.dart';
import '../widgets/car_error_state.dart';
import '../widgets/cardle_guess_row.dart';
import '../widgets/cardle_header_row.dart';

class CardleScreen extends StatefulWidget {
  final String collectionId;
  final String title;

  const CardleScreen({
    super.key,
    required this.collectionId,
    required this.title,
  });

  @override
  State<CardleScreen> createState() => _CardleScreenState();
}

class _CardleScreenState extends State<CardleScreen> {
  final _random = Random();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _tableScrollController = ScrollController();
  CarLoadStatus _status = CarLoadStatus.loading;
  List<Car> _availableCars = [];
  Car? _answer;
  final List<CarGuessResult> _guesses = [];
  List<Car> _suggestions = [];
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
    setState(() => _status = CarLoadStatus.loading);

    final collectionCars = await CarService.loadCars(widget.collectionId);

    if (!mounted) return;
    if (collectionCars.isEmpty) {
      setState(() => _status = CarLoadStatus.error);
      return;
    }

    setState(() {
      _availableCars = collectionCars;
      _answer = collectionCars[_random.nextInt(collectionCars.length)];
      _guesses.clear();
      _suggestions = [];
      _isAnswerRevealed = false;
      _hasWon = false;
      _status = CarLoadStatus.ready;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchFocusNode.requestFocus();
    });
  }

  void _restart() {
    setState(() {
      _answer = _availableCars[_random.nextInt(_availableCars.length)];
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

    final guessedNames = _guesses.map((result) => result.car.name).toSet();
    setState(() {
      _suggestions = _availableCars
          .where(
            (car) => !guessedNames.contains(car.name) && car.matchesQuery(query),
          )
          .toList();
    });
  }

  void _submitGuess(Car car) {
    final alreadyGuessed = _guesses.any((result) => result.car.name == car.name);
    if (_status != CarLoadStatus.ready || _isAnswerRevealed || _hasWon || alreadyGuessed) {
      return;
    }

    final result = CarGuessResult.evaluate(car, _answer!);
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

  Future<void> _openCarDex() async {
    final selected = await showCarDexDialog(context, _availableCars);
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
      backgroundColor: kCarBgColor,
      appBar: AppBar(
        title: Text('Cardle: ${widget.title}'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_status == CarLoadStatus.ready)
            IconButton(
              onPressed: _openCarDex,
              icon: const Icon(Icons.menu_book_rounded),
              tooltip: 'car_dexTooltip'.tr,
            ),
        ],
      ),
      body: SafeArea(
        child: _status == CarLoadStatus.loading
            ? const Center(
                child: CircularProgressIndicator(color: kCarAccentColor),
              )
            : _status == CarLoadStatus.error
                ? CarErrorState(onRetry: _loadAndStartGame)
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
            const CardleHeaderRow(),
            ..._guesses.asMap().entries.map(
                  (entry) => CardleGuessRow(
                    key: ValueKey(entry.value.car.name),
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
                    'car_typeToStart'.tr,
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
        color: kCarHeaderCellColor,
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
      color: kCarPanelColor,
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
                    final car = _suggestions[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        car.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${car.brand} · ${car.bodyType}',
                        style: const TextStyle(color: Colors.white60),
                      ),
                      onTap: () => _submitGuess(car),
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
                      hintText: 'car_inputHint'.tr,
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      filled: true,
                      fillColor: kCarBgColor,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _isAnswerRevealed || _hasWon ? null : _revealAnswer,
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                  child: Text('common_giveUp'.tr),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

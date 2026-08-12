import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/celebrity.dart';
import '../models/celebrity_guess_result.dart';
import '../models/celebrity_load_status.dart';
import '../services/celebrity_service.dart';
import '../theme/celebrity_theme.dart';
import '../widgets/celebrity_dex_dialog.dart';
import '../widgets/celebrity_error_state.dart';
import '../widgets/celebrity_guess_row.dart';
import '../widgets/celebrity_header_row.dart';

class CelebritydleScreen extends StatefulWidget {
  final String collectionId;
  final String title;

  const CelebritydleScreen({
    super.key,
    required this.collectionId,
    required this.title,
  });

  @override
  State<CelebritydleScreen> createState() => _CelebritydleScreenState();
}

class _CelebritydleScreenState extends State<CelebritydleScreen> {
  final _random = Random();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _tableScrollController = ScrollController();
  CelebrityLoadStatus _status = CelebrityLoadStatus.loading;
  List<Celebrity> _availableCelebrities = [];
  Celebrity? _answer;
  final List<CelebrityGuessResult> _guesses = [];
  List<Celebrity> _suggestions = [];
  bool _isAnswerRevealed = false;
  bool _hasWon = false;

  bool get _includeOccupation => widget.collectionId == 'all';
  bool get _includeYoutuberFields =>
      widget.collectionId == 'youtuber' ||
      widget.collectionId == 'global_youtuber';

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
    setState(() => _status = CelebrityLoadStatus.loading);

    final celebrities =
        await CelebrityService.loadCelebrities(widget.collectionId);

    if (!mounted) return;
    if (celebrities.isEmpty) {
      setState(() => _status = CelebrityLoadStatus.error);
      return;
    }

    setState(() {
      _availableCelebrities = celebrities;
      _answer = celebrities[_random.nextInt(celebrities.length)];
      _guesses.clear();
      _suggestions = [];
      _isAnswerRevealed = false;
      _hasWon = false;
      _status = CelebrityLoadStatus.ready;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchFocusNode.requestFocus();
    });
  }

  void _restart() {
    setState(() {
      _answer = _availableCelebrities[_random.nextInt(_availableCelebrities.length)];
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

    final guessedNames = _guesses.map((result) => result.celebrity.name).toSet();
    setState(() {
      _suggestions = _availableCelebrities
          .where(
            (celebrity) =>
                !guessedNames.contains(celebrity.name) &&
                celebrity.matchesQuery(query),
          )
          .toList();
    });
  }

  void _submitGuess(Celebrity celebrity) {
    final alreadyGuessed =
        _guesses.any((result) => result.celebrity.name == celebrity.name);
    if (_status != CelebrityLoadStatus.ready ||
        _isAnswerRevealed ||
        _hasWon ||
        alreadyGuessed) {
      return;
    }

    final result = CelebrityGuessResult.evaluate(
      celebrity,
      _answer!,
      includeOccupation: _includeOccupation,
      includeYoutuberFields: _includeYoutuberFields,
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

  Future<void> _openCelebrityDex() async {
    final selected =
        await showCelebrityDexDialog(context, _availableCelebrities);
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
      backgroundColor: kCelebrityBgColor,
      appBar: AppBar(
        title: Text(
          'celebrity_screenTitle'.trParams({'title': widget.title}),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_status == CelebrityLoadStatus.ready)
            IconButton(
              onPressed: _openCelebrityDex,
              icon: const Icon(Icons.menu_book_rounded),
              tooltip: 'celebrity_dexTooltip'.tr,
            ),
        ],
      ),
      body: SafeArea(
        child: _status == CelebrityLoadStatus.loading
            ? const Center(
                child: CircularProgressIndicator(color: kCelebrityAccentColor),
              )
            : _status == CelebrityLoadStatus.error
                ? CelebrityErrorState(onRetry: _loadAndStartGame)
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
            CelebrityHeaderRow(
              includeOccupation: _includeOccupation,
              includeYoutuberFields: _includeYoutuberFields,
            ),
            ..._guesses.asMap().entries.map(
                  (entry) => CelebrityGuessRow(
                    key: ValueKey(entry.value.celebrity.name),
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
                    'celebrity_typeToStart'.tr,
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
        color: kCelebrityHeaderCellColor,
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
      color: kCelebrityPanelColor,
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
                    final celebrity = _suggestions[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        celebrity.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${celebrityCollectionLabel(celebrity.collection)} · ${celebrity.displaySubCategory}',
                        style: const TextStyle(color: Colors.white60),
                      ),
                      onTap: () => _submitGuess(celebrity),
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
                      hintText: 'celebrity_inputHint'.tr,
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      filled: true,
                      fillColor: kCelebrityBgColor,
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

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/fairytail_character.dart';
import '../models/fairytail_guess_result.dart';
import '../models/fairytail_load_status.dart';
import '../services/fairytail_character_service.dart';
import '../theme/fairydle_theme.dart';
import '../widgets/fairytail_dex_dialog.dart';
import '../widgets/fairytail_error_state.dart';
import '../widgets/fairydle_guess_row.dart';
import '../widgets/fairydle_header_row.dart';

class FairydleScreen extends StatefulWidget {
  const FairydleScreen({super.key});

  @override
  State<FairydleScreen> createState() => _FairydleScreenState();
}

class _FairydleScreenState extends State<FairydleScreen> {
  final _random = Random();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _tableScrollController = ScrollController();
  FairytailLoadStatus _status = FairytailLoadStatus.loading;
  List<FairytailCharacter> _availableCharacters = [];
  FairytailCharacter? _answer;
  final List<FairytailGuessResult> _guesses = [];
  List<FairytailCharacter> _suggestions = [];
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
    setState(() => _status = FairytailLoadStatus.loading);

    final characters = await FairytailCharacterService.loadCharacters();

    if (!mounted) return;
    if (characters.isEmpty) {
      setState(() => _status = FairytailLoadStatus.error);
      return;
    }

    setState(() {
      _availableCharacters = characters;
      _answer = characters[_random.nextInt(characters.length)];
      _guesses.clear();
      _suggestions = [];
      _isAnswerRevealed = false;
      _hasWon = false;
      _status = FairytailLoadStatus.ready;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchFocusNode.requestFocus();
    });
  }

  void _restart() {
    setState(() {
      _answer =
          _availableCharacters[_random.nextInt(_availableCharacters.length)];
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

    final guessedNames = _guesses.map((result) => result.character.name).toSet();
    setState(() {
      _suggestions = _availableCharacters
          .where(
            (character) =>
                !guessedNames.contains(character.name) &&
                character.matchesQuery(query),
          )
          .toList();
    });
  }

  void _submitGuess(FairytailCharacter character) {
    final alreadyGuessed =
        _guesses.any((result) => result.character.name == character.name);
    if (_status != FairytailLoadStatus.ready ||
        _isAnswerRevealed ||
        _hasWon ||
        alreadyGuessed) {
      return;
    }

    final result = FairytailGuessResult.evaluate(character, _answer!);
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

  Future<void> _openFairytailDex() async {
    final selected = await showFairytailDexDialog(context, _availableCharacters);
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
      backgroundColor: kFairytailBgColor,
      appBar: AppBar(
        title: const Text('Fairydle'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_status == FairytailLoadStatus.ready)
            IconButton(
              onPressed: _openFairytailDex,
              icon: const Icon(Icons.menu_book_rounded),
              tooltip: 'fairytail_dexTooltip'.tr,
            ),
        ],
      ),
      body: SafeArea(
        child: _status == FairytailLoadStatus.loading
            ? const Center(
                child: CircularProgressIndicator(color: kFairytailAccentColor),
              )
            : _status == FairytailLoadStatus.error
                ? FairytailErrorState(onRetry: _loadAndStartGame)
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Text(
                          'fairytail_unlimitedGuesses'.tr,
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
            const FairydleHeaderRow(),
            ..._guesses.asMap().entries.map(
                  (entry) => FairydleGuessRow(
                    key: ValueKey(entry.value.character.name),
                    result: entry.value,
                    animate: entry.key == 0,
                  ),
                ),
            if (_guesses.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: SizedBox(
                  width: 930,
                  child: Text(
                    'fairytail_typeToStart'.tr,
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
        color: kFairytailHeaderCellColor,
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
      color: kFairytailPanelColor,
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
                    final character = _suggestions[index];
                    return ListTile(
                      dense: true,
                      leading: character.imageUrl == null
                          ? null
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: CachedNetworkImage(
                                imageUrl: character.imageUrl!,
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                                errorWidget: (c, u, e) => const Icon(
                                  Icons.local_fire_department_outlined,
                                  size: 20,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                      title: Text(
                        character.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${character.displayGuild} · ${character.displayGuildRank}',
                        style: const TextStyle(color: Colors.white60),
                      ),
                      onTap: () => _submitGuess(character),
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
                      hintText: 'fairytail_inputHint'.tr,
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      filled: true,
                      fillColor: kFairytailBgColor,
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

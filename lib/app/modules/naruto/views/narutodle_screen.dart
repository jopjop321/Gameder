import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/naruto_character.dart';
import '../models/naruto_guess_result.dart';
import '../models/naruto_load_status.dart';
import '../services/naruto_character_service.dart';
import '../theme/narutodle_theme.dart';
import '../widgets/naruto_dex_dialog.dart';
import '../widgets/naruto_error_state.dart';
import '../widgets/narutodle_guess_row.dart';
import '../widgets/narutodle_header_row.dart';

class NarutodleScreen extends StatefulWidget {
  const NarutodleScreen({super.key});

  @override
  State<NarutodleScreen> createState() => _NarutodleScreenState();
}

class _NarutodleScreenState extends State<NarutodleScreen> {
  final _random = Random();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _tableScrollController = ScrollController();
  NarutoLoadStatus _status = NarutoLoadStatus.loading;
  List<NarutoCharacter> _availableCharacters = [];
  NarutoCharacter? _answer;
  final List<NarutoGuessResult> _guesses = [];
  List<NarutoCharacter> _suggestions = [];
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
    setState(() => _status = NarutoLoadStatus.loading);

    final characters = await NarutoCharacterService.loadCharacters();

    if (!mounted) return;
    if (characters.isEmpty) {
      setState(() => _status = NarutoLoadStatus.error);
      return;
    }

    setState(() {
      _availableCharacters = characters;
      _answer = characters[_random.nextInt(characters.length)];
      _guesses.clear();
      _suggestions = [];
      _isAnswerRevealed = false;
      _hasWon = false;
      _status = NarutoLoadStatus.ready;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchFocusNode.requestFocus();
    });
  }

  void _restart() {
    setState(() {
      _answer = _availableCharacters[_random.nextInt(_availableCharacters.length)];
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
                !guessedNames.contains(character.name) && character.matchesQuery(query),
          )
          .toList();
    });
  }

  void _submitGuess(NarutoCharacter character) {
    final alreadyGuessed =
        _guesses.any((result) => result.character.name == character.name);
    if (_status != NarutoLoadStatus.ready || _isAnswerRevealed || _hasWon || alreadyGuessed) {
      return;
    }

    final result = NarutoGuessResult.evaluate(character, _answer!);
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

  Future<void> _openNarutoDex() async {
    final selected = await showNarutoDexDialog(context, _availableCharacters);
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
      backgroundColor: kNarutoBgColor,
      appBar: AppBar(
        title: const Text('Narutodle'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_status == NarutoLoadStatus.ready)
            IconButton(
              onPressed: _openNarutoDex,
              icon: const Icon(Icons.menu_book_rounded),
              tooltip: 'naruto_dexTooltip'.tr,
            ),
        ],
      ),
      body: SafeArea(
        child: _status == NarutoLoadStatus.loading
            ? const Center(
                child: CircularProgressIndicator(color: kNarutoAccentColor),
              )
            : _status == NarutoLoadStatus.error
                ? NarutoErrorState(onRetry: _loadAndStartGame)
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Text(
                          'naruto_unlimitedGuesses'.tr,
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
            const NarutodleHeaderRow(),
            ..._guesses.asMap().entries.map(
                  (entry) => NarutodleGuessRow(
                    key: ValueKey(entry.value.character.name),
                    result: entry.value,
                    animate: entry.key == 0,
                  ),
                ),
            if (_guesses.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: SizedBox(
                  width: 1030,
                  child: Text(
                    'naruto_typeToStart'.tr,
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
        color: kNarutoHeaderCellColor,
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
      color: kNarutoPanelColor,
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
                        '${character.displayVillage} · ${character.displayRank}',
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
                      hintText: 'naruto_inputHint'.tr,
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      filled: true,
                      fillColor: kNarutoBgColor,
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

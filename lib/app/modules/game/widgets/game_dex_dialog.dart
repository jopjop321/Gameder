import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/video_game.dart';
import '../theme/gamedle_theme.dart';

Future<VideoGame?> showGameDexDialog(
  BuildContext context,
  List<VideoGame> availableGames,
) {
  final searchController = TextEditingController();
  var selectedGenreGroup = 'ทั้งหมด';

  return showDialog<VideoGame>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setModalState) {
        final genreGroups =
            availableGames.map((game) => game.genreGroup).toSet().toList()
              ..sort();
        final filteredGames = availableGames.where((game) {
          final hasSelectedGenreGroup = selectedGenreGroup == 'ทั้งหมด' ||
              game.genreGroup == selectedGenreGroup;
          return hasSelectedGenreGroup && game.matchesQuery(searchController.text);
        }).toList();

        return Dialog(
          backgroundColor: kGamePanelColor,
          insetPadding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620, maxHeight: 680),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 8, 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.videogame_asset_rounded,
                        color: kGameAccentColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'game_dexTitle'.trParams(
                            {'count': '${filteredGames.length}'},
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                        tooltip: 'common_close'.tr,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (_) => setModalState(() {}),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'game_dexSearchHint'.tr,
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: kGameBgColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 156,
                        child: DropdownButtonFormField<String>(
                          value: selectedGenreGroup,
                          isExpanded: true,
                          dropdownColor: kGamePanelColor,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: kGameBgColor,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'ทั้งหมด',
                              child: Text('game_dexAllGenres'.tr),
                            ),
                            ...genreGroups.map(
                              (genreGroup) => DropdownMenuItem(
                                value: genreGroup,
                                child: Text(
                                  genreGroup,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (genreGroup) {
                            if (genreGroup == null) return;
                            setModalState(() => selectedGenreGroup = genreGroup);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredGames.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white12, height: 1),
                    itemBuilder: (context, index) {
                      final game = filteredGames[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: kGameHeaderCellColor,
                          child: Icon(
                            Icons.sports_esports_outlined,
                            color: kGameAccentColor,
                          ),
                        ),
                        title: Text(
                          game.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${game.developer} · ${game.genre} · ${game.releaseYear}',
                          style: const TextStyle(color: Colors.white60),
                        ),
                        onTap: () => Navigator.of(dialogContext).pop(game),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  ).whenComplete(searchController.dispose);
}

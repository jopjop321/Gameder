import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/song.dart';
import '../theme/musicdle_theme.dart';

Future<Song?> showSongDexDialog(
  BuildContext context,
  List<Song> availableSongs,
) {
  final searchController = TextEditingController();
  var selectedGenreGroup = 'ทั้งหมด';

  return showDialog<Song>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setModalState) {
        final genreGroups =
            availableSongs.map((song) => song.genreGroup).toSet().toList()
              ..sort();
        final filteredSongs = availableSongs.where((song) {
          final hasSelectedGenreGroup = selectedGenreGroup == 'ทั้งหมด' ||
              song.genreGroup == selectedGenreGroup;
          return hasSelectedGenreGroup && song.matchesQuery(searchController.text);
        }).toList();

        return Dialog(
          backgroundColor: kMusicPanelColor,
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
                        Icons.music_note_outlined,
                        color: kMusicAccentColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'music_dexTitle'.trParams(
                            {'count': '${filteredSongs.length}'},
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
                            hintText: 'music_dexSearchHint'.tr,
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: kMusicBgColor,
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
                          dropdownColor: kMusicPanelColor,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: kMusicBgColor,
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
                              child: Text('music_dexAllGenres'.tr),
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
                    itemCount: filteredSongs.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white12, height: 1),
                    itemBuilder: (context, index) {
                      final song = filteredSongs[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: kMusicHeaderCellColor,
                          child: Icon(
                            Icons.music_note_outlined,
                            color: kMusicAccentColor,
                          ),
                        ),
                        title: Text(
                          song.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${song.artist} · ${song.genre} · ${song.releaseYear}',
                          style: const TextStyle(color: Colors.white60),
                        ),
                        onTap: () => Navigator.of(dialogContext).pop(song),
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

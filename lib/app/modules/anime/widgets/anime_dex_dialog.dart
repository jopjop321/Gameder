import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/anime.dart';
import '../theme/anidle_theme.dart';

Future<Anime?> showAnimeDexDialog(
  BuildContext context,
  List<Anime> availableAnimes,
) {
  final searchController = TextEditingController();
  var selectedStudio = 'ทั้งหมด';

  return showDialog<Anime>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setModalState) {
        final studios =
            availableAnimes.map((anime) => anime.studio).toSet().toList()
              ..sort();
        final filteredAnimes = availableAnimes.where((anime) {
          final hasSelectedStudio =
              selectedStudio == 'ทั้งหมด' || anime.studio == selectedStudio;
          return hasSelectedStudio && anime.matchesQuery(searchController.text);
        }).toList();

        return Dialog(
          backgroundColor: kAnimePanelColor,
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
                        Icons.menu_book_rounded,
                        color: kAnimeAccentColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'anime_dexTitle'.trParams(
                            {'count': '${filteredAnimes.length}'},
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
                            hintText: 'anime_dexSearchHint'.tr,
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: kAnimeBgColor,
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
                          value: selectedStudio,
                          isExpanded: true,
                          dropdownColor: kAnimePanelColor,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: kAnimeBgColor,
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
                              child: Text('anime_dexAllStudios'.tr),
                            ),
                            ...studios.map(
                              (studio) => DropdownMenuItem(
                                value: studio,
                                child: Text(
                                  studio,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (studio) {
                            if (studio == null) return;
                            setModalState(() => selectedStudio = studio);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredAnimes.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white12, height: 1),
                    itemBuilder: (context, index) {
                      final anime = filteredAnimes[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: kAnimeHeaderCellColor,
                          backgroundImage: anime.imageUrl == null
                              ? null
                              : CachedNetworkImageProvider(anime.imageUrl!),
                          child: anime.imageUrl == null
                              ? const Icon(
                                  Icons.movie_filter_outlined,
                                  color: kAnimeAccentColor,
                                )
                              : null,
                        ),
                        title: Text(
                          anime.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${anime.studio} · ${anime.format} · ${anime.releaseYear}',
                          style: const TextStyle(color: Colors.white60),
                        ),
                        onTap: () => Navigator.of(dialogContext).pop(anime),
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

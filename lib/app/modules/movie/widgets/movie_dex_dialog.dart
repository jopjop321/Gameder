import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/movie.dart';
import '../theme/moviedle_theme.dart';

Future<Movie?> showMovieDexDialog(
  BuildContext context,
  List<Movie> availableMovies,
) {
  final searchController = TextEditingController();
  var selectedGenreGroup = 'ทั้งหมด';

  return showDialog<Movie>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setModalState) {
        final genreGroups =
            availableMovies.map((movie) => movie.genreGroup).toSet().toList()
              ..sort();
        final filteredMovies = availableMovies.where((movie) {
          final hasSelectedGenreGroup = selectedGenreGroup == 'ทั้งหมด' ||
              movie.genreGroup == selectedGenreGroup;
          return hasSelectedGenreGroup && movie.matchesQuery(searchController.text);
        }).toList();

        return Dialog(
          backgroundColor: kMoviePanelColor,
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
                        Icons.local_movies_outlined,
                        color: kMovieAccentColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'movie_dexTitle'.trParams(
                            {'count': '${filteredMovies.length}'},
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
                            hintText: 'movie_dexSearchHint'.tr,
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: kMovieBgColor,
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
                          dropdownColor: kMoviePanelColor,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: kMovieBgColor,
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
                              child: Text('movie_dexAllGenres'.tr),
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
                    itemCount: filteredMovies.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white12, height: 1),
                    itemBuilder: (context, index) {
                      final movie = filteredMovies[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: kMovieHeaderCellColor,
                          child: Icon(
                            Icons.local_movies_outlined,
                            color: kMovieAccentColor,
                          ),
                        ),
                        title: Text(
                          movie.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${movie.director} · ${movie.genre} · ${movie.releaseYear}',
                          style: const TextStyle(color: Colors.white60),
                        ),
                        onTap: () => Navigator.of(dialogContext).pop(movie),
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

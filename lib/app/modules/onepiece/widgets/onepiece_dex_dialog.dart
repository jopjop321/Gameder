import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/onepiece_character.dart';
import '../theme/onepiecedle_theme.dart';

Future<OnePieceCharacter?> showOnePieceDexDialog(
  BuildContext context,
  List<OnePieceCharacter> availableCharacters,
) {
  final searchController = TextEditingController();
  var selectedCrew = 'ทั้งหมด';

  return showDialog<OnePieceCharacter>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setModalState) {
        final crews =
            availableCharacters.map((c) => c.crew).toSet().toList()..sort();
        final crewDisplayNames = {
          for (final c in availableCharacters) c.crew: c.displayCrew,
        };
        final filteredCharacters = availableCharacters.where((character) {
          final hasSelectedCrew =
              selectedCrew == 'ทั้งหมด' || character.crew == selectedCrew;
          return hasSelectedCrew && character.matchesQuery(searchController.text);
        }).toList();

        return Dialog(
          backgroundColor: kOnePiecePanelColor,
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
                        Icons.sailing_outlined,
                        color: kOnePieceAccentColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'onepiece_dexTitle'.trParams(
                            {'count': '${filteredCharacters.length}'},
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
                            hintText: 'onepiece_dexSearchHint'.tr,
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: kOnePieceBgColor,
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
                          value: selectedCrew,
                          isExpanded: true,
                          dropdownColor: kOnePiecePanelColor,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: kOnePieceBgColor,
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
                              child: Text('onepiece_dexAllCrews'.tr),
                            ),
                            ...crews.map(
                              (crew) => DropdownMenuItem(
                                value: crew,
                                child: Text(
                                  crewDisplayNames[crew] ?? crew,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (crew) {
                            if (crew == null) return;
                            setModalState(() => selectedCrew = crew);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredCharacters.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white12, height: 1),
                    itemBuilder: (context, index) {
                      final character = filteredCharacters[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: kOnePieceHeaderCellColor,
                          backgroundImage: character.imageUrl == null
                              ? null
                              : CachedNetworkImageProvider(character.imageUrl!),
                          child: character.imageUrl == null
                              ? const Icon(
                                  Icons.sailing_outlined,
                                  color: kOnePieceAccentColor,
                                )
                              : null,
                        ),
                        title: Text(
                          character.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${character.displayCrew} · ${character.displayRole}',
                          style: const TextStyle(color: Colors.white60),
                        ),
                        onTap: () => Navigator.of(dialogContext).pop(character),
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

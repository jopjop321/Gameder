import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/blackclover_character.dart';
import '../theme/cloverdle_theme.dart';

Future<BlackcloverCharacter?> showBlackcloverDexDialog(
  BuildContext context,
  List<BlackcloverCharacter> availableCharacters,
) {
  final searchController = TextEditingController();
  var selectedSquad = 'ทั้งหมด';

  return showDialog<BlackcloverCharacter>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setModalState) {
        final squads =
            availableCharacters.map((c) => c.squad).toSet().toList()..sort();
        final squadDisplayNames = {
          for (final c in availableCharacters) c.squad: c.displaySquad,
        };
        final filteredCharacters = availableCharacters.where((character) {
          final hasSelectedSquad =
              selectedSquad == 'ทั้งหมด' || character.squad == selectedSquad;
          return hasSelectedSquad && character.matchesQuery(searchController.text);
        }).toList();

        return Dialog(
          backgroundColor: kBlackcloverPanelColor,
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
                        Icons.auto_awesome,
                        color: kBlackcloverAccentColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'blackclover_dexTitle'.trParams(
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
                            hintText: 'blackclover_dexSearchHint'.tr,
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: kBlackcloverBgColor,
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
                          value: selectedSquad,
                          isExpanded: true,
                          dropdownColor: kBlackcloverPanelColor,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: kBlackcloverBgColor,
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
                              child: Text('blackclover_dexAllSquads'.tr),
                            ),
                            ...squads.map(
                              (squad) => DropdownMenuItem(
                                value: squad,
                                child: Text(
                                  squadDisplayNames[squad] ?? squad,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (squad) {
                            if (squad == null) return;
                            setModalState(() => selectedSquad = squad);
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
                          backgroundColor: kBlackcloverHeaderCellColor,
                          backgroundImage: character.imageUrl == null
                              ? null
                              : CachedNetworkImageProvider(character.imageUrl!),
                          child: character.imageUrl == null
                              ? const Icon(
                                  Icons.auto_awesome,
                                  color: kBlackcloverAccentColor,
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
                          '${character.displaySquad} · ${character.displayRole}',
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

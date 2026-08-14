import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/naruto_character.dart';
import '../theme/narutodle_theme.dart';

Future<NarutoCharacter?> showNarutoDexDialog(
  BuildContext context,
  List<NarutoCharacter> availableCharacters,
) {
  final searchController = TextEditingController();
  var selectedVillage = 'ทั้งหมด';

  return showDialog<NarutoCharacter>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setModalState) {
        final villages =
            availableCharacters.map((c) => c.village).toSet().toList()..sort();
        final villageDisplayNames = {
          for (final c in availableCharacters) c.village: c.displayVillage,
        };
        final filteredCharacters = availableCharacters.where((character) {
          final hasSelectedVillage = selectedVillage == 'ทั้งหมด' ||
              character.village == selectedVillage;
          return hasSelectedVillage &&
              character.matchesQuery(searchController.text);
        }).toList();

        return Dialog(
          backgroundColor: kNarutoPanelColor,
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
                        Icons.local_fire_department_outlined,
                        color: kNarutoAccentColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'naruto_dexTitle'.trParams(
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
                            hintText: 'naruto_dexSearchHint'.tr,
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: kNarutoBgColor,
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
                          value: selectedVillage,
                          isExpanded: true,
                          dropdownColor: kNarutoPanelColor,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: kNarutoBgColor,
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
                              child: Text('naruto_dexAllVillages'.tr),
                            ),
                            ...villages.map(
                              (village) => DropdownMenuItem(
                                value: village,
                                child: Text(
                                  villageDisplayNames[village] ?? village,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (village) {
                            if (village == null) return;
                            setModalState(() => selectedVillage = village);
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
                          backgroundColor: kNarutoHeaderCellColor,
                          backgroundImage: character.imageUrl == null
                              ? null
                              : CachedNetworkImageProvider(character.imageUrl!),
                          child: character.imageUrl == null
                              ? const Icon(
                                  Icons.local_fire_department_outlined,
                                  color: kNarutoAccentColor,
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
                          '${character.displayVillage} · ${character.displayRank}',
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

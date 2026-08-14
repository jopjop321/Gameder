import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/aot_character.dart';
import '../theme/titandle_theme.dart';

Future<AotCharacter?> showAotDexDialog(
  BuildContext context,
  List<AotCharacter> availableCharacters,
) {
  final searchController = TextEditingController();
  var selectedAffiliation = 'ทั้งหมด';

  return showDialog<AotCharacter>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setModalState) {
        final affiliations =
            availableCharacters.map((c) => c.affiliation).toSet().toList()
              ..sort();
        final affiliationDisplayNames = {
          for (final c in availableCharacters) c.affiliation: c.displayAffiliation,
        };
        final filteredCharacters = availableCharacters.where((character) {
          final hasSelectedAffiliation = selectedAffiliation == 'ทั้งหมด' ||
              character.affiliation == selectedAffiliation;
          return hasSelectedAffiliation &&
              character.matchesQuery(searchController.text);
        }).toList();

        return Dialog(
          backgroundColor: kAotPanelColor,
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
                        Icons.terrain_rounded,
                        color: kAotAccentColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'aot_dexTitle'.trParams(
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
                            hintText: 'aot_dexSearchHint'.tr,
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: kAotBgColor,
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
                          value: selectedAffiliation,
                          isExpanded: true,
                          dropdownColor: kAotPanelColor,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: kAotBgColor,
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
                              child: Text('aot_dexAllAffiliations'.tr),
                            ),
                            ...affiliations.map(
                              (affiliation) => DropdownMenuItem(
                                value: affiliation,
                                child: Text(
                                  affiliationDisplayNames[affiliation] ??
                                      affiliation,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (affiliation) {
                            if (affiliation == null) return;
                            setModalState(() => selectedAffiliation = affiliation);
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
                          backgroundColor: kAotHeaderCellColor,
                          backgroundImage: character.imageUrl == null
                              ? null
                              : CachedNetworkImageProvider(character.imageUrl!),
                          child: character.imageUrl == null
                              ? const Icon(
                                  Icons.terrain_rounded,
                                  color: kAotAccentColor,
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
                          '${character.displayAffiliation} · ${character.displayRank}',
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

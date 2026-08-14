import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/fairytail_character.dart';
import '../theme/fairydle_theme.dart';

Future<FairytailCharacter?> showFairytailDexDialog(
  BuildContext context,
  List<FairytailCharacter> availableCharacters,
) {
  final searchController = TextEditingController();
  var selectedGuild = 'ทั้งหมด';

  return showDialog<FairytailCharacter>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setModalState) {
        final guilds =
            availableCharacters.map((c) => c.guild).toSet().toList()..sort();
        final guildDisplayNames = {
          for (final c in availableCharacters) c.guild: c.displayGuild,
        };
        final filteredCharacters = availableCharacters.where((character) {
          final hasSelectedGuild =
              selectedGuild == 'ทั้งหมด' || character.guild == selectedGuild;
          return hasSelectedGuild &&
              character.matchesQuery(searchController.text);
        }).toList();

        return Dialog(
          backgroundColor: kFairytailPanelColor,
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
                        color: kFairytailAccentColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'fairytail_dexTitle'.trParams(
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
                            hintText: 'fairytail_dexSearchHint'.tr,
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: kFairytailBgColor,
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
                          value: selectedGuild,
                          isExpanded: true,
                          dropdownColor: kFairytailPanelColor,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: kFairytailBgColor,
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
                              child: Text('fairytail_dexAllGuilds'.tr),
                            ),
                            ...guilds.map(
                              (guild) => DropdownMenuItem(
                                value: guild,
                                child: Text(
                                  guildDisplayNames[guild] ?? guild,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (guild) {
                            if (guild == null) return;
                            setModalState(() => selectedGuild = guild);
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
                          backgroundColor: kFairytailHeaderCellColor,
                          backgroundImage: character.imageUrl == null
                              ? null
                              : CachedNetworkImageProvider(character.imageUrl!),
                          child: character.imageUrl == null
                              ? const Icon(
                                  Icons.local_fire_department_outlined,
                                  color: kFairytailAccentColor,
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
                          '${character.displayGuild} · ${character.displayGuildRank}',
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/pokemon.dart';
import '../theme/pokedle_theme.dart';

class PokedleSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<Pokemon> suggestions;
  final ValueChanged<Pokemon> onSelect;

  const PokedleSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.suggestions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (suggestions.isNotEmpty)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final p = suggestions[index];
                    return ListTile(
                      dense: true,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: p.imageUrl,
                          width: 32,
                          height: 32,
                          fit: BoxFit.contain,
                          errorWidget: (c, u, e) =>
                              const Icon(Icons.catching_pokemon, size: 20),
                        ),
                      ),
                      title: Text(
                        p.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        Get.locale?.languageCode == 'th'
                            ? '${p.name} · ${p.romajiTh} · ${p.romajiEn}'
                            : '${p.nameTh} · ${p.romajiTh} · ${p.romajiEn}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      onTap: () => onSelect(p),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kBgColor,
                  hintText: 'pokedle_searchHint'.tr,
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

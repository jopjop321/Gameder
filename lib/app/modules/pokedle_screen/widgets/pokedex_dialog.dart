import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../controllers/pokemon.dart';
import '../theme/pokedle_theme.dart';

Future<void> showPokedexDialog(
  BuildContext context,
  List<Pokemon> pokedex,
) {
  final searchController = TextEditingController();
  var selectedGeneration = 0;

  return showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setModalState) {
        final generations = pokedex
            .map((pokemon) => pokemon.generation)
            .toSet()
            .toList()
          ..sort();
        final filteredPokemon = pokedex
            .where(
              (pokemon) =>
                  (selectedGeneration == 0 ||
                      pokemon.generation == selectedGeneration) &&
                  (searchController.text.trim().isEmpty ||
                      pokemon.matchesQuery(searchController.text)),
            )
            .toList();

        return Dialog(
          backgroundColor: kCardColor,
          insetPadding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760, maxHeight: 680),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 8, 12),
                  child: Row(
                    children: [
                      const Icon(Icons.menu_book_rounded, color: kAccentColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pokédex (${filteredPokemon.length})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close',
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
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
                            hintText: 'ค้นหาชื่อหรือเลข Pokédex',
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: kBgColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 132,
                        child: DropdownButtonFormField<int>(
                          value: selectedGeneration,
                          dropdownColor: kCardColor,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: kBgColor,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: 0,
                              child: Text('All Gen'),
                            ),
                            ...generations.map(
                              (generation) => DropdownMenuItem(
                                value: generation,
                                child: Text('Gen $generation'),
                              ),
                            ),
                          ],
                          onChanged: (generation) {
                            if (generation != null) {
                              setModalState(
                                () => selectedGeneration = generation,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = (constraints.maxWidth / 130)
                          .floor()
                          .clamp(2, 5)
                          .toInt();
                      return filteredPokemon.isEmpty
                          ? const Center(
                              child: Text(
                                'No Pokémon found',
                                style: TextStyle(color: Colors.white54),
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: filteredPokemon.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                mainAxisExtent: 190,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) => PokedexEntryCard(
                                pokemon: filteredPokemon[index],
                              ),
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

class PokedexEntryCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokedexEntryCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: pokemon.imageUrl,
              fit: BoxFit.contain,
              placeholder: (_, __) => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (_, __, ___) => const Icon(
                Icons.image_not_supported_outlined,
                color: Colors.white38,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
            child: Column(
              children: [
                Text(
                  '#${pokemon.id.toString().padLeft(3, '0')}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  pokemon.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  pokemon.nameTh,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

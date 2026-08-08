import 'package:flutter/material.dart';

import '../models/food.dart';
import '../theme/foodle_theme.dart';

Future<void> showFoodDexDialog(
  BuildContext context,
  List<Food> availableFoods,
) {
  final searchController = TextEditingController();
  var selectedCountry = 'ทั้งหมด';

  return showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setModalState) {
        final countries =
            availableFoods.map((food) => food.country).toSet().toList()
              ..sort();
        final filteredFoods = availableFoods.where((food) {
          final hasSelectedCountry =
              selectedCountry == 'ทั้งหมด' || food.country == selectedCountry;
          return hasSelectedCountry && food.matchesQuery(searchController.text);
        }).toList();

        return Dialog(
          backgroundColor: kFoodPanelColor,
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
                        color: kFoodAccentColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'คลังอาหาร (${filteredFoods.length})',
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
                        tooltip: 'ปิด',
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
                            hintText: 'ค้นหาชื่ออาหาร',
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: kFoodBgColor,
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
                          value: selectedCountry,
                          dropdownColor: kFoodPanelColor,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: kFoodBgColor,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: 'ทั้งหมด',
                              child: Text('ทุกประเทศ'),
                            ),
                            ...countries.map(
                              (country) => DropdownMenuItem(
                                value: country,
                                child: Text(
                                  country,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (country) {
                            if (country == null) return;
                            setModalState(() => selectedCountry = country);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredFoods.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white12, height: 1),
                    itemBuilder: (context, index) {
                      final food = filteredFoods[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: kFoodHeaderCellColor,
                          child: Icon(
                            Icons.restaurant,
                            color: kFoodAccentColor,
                          ),
                        ),
                        title: Text(
                          food.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${food.country} · ${food.dishType} · ${food.cookingMethod}',
                          style: const TextStyle(color: Colors.white60),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/food.dart';
import '../theme/foodle_theme.dart';

const _kAllOption = 'ทั้งหมด';

/// A region filter is only useful when every dish carries a region and the
/// region set is small (e.g. Thailand's 5 regions). Datasets with
/// prefecture-level or missing region data (Japan, world, ...) fall back to
/// filtering by country instead.
bool _hasUsableRegionData(List<Food> foods) {
  if (foods.isEmpty) return false;
  final regions = <String>{};
  for (final food in foods) {
    final region = food.region;
    if (region == null) return false;
    regions.add(region);
  }
  return regions.length <= 8;
}

Future<Food?> showFoodDexDialog(
  BuildContext context,
  List<Food> availableFoods,
) {
  final searchController = TextEditingController();
  final useRegionFilter = _hasUsableRegionData(availableFoods);
  var selectedRegionOrCountry = _kAllOption;
  var selectedCookingMethod = _kAllOption;

  return showDialog<Food>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setModalState) {
        final regionOrCountryValues =
            (useRegionFilter
                    ? availableFoods.map((food) => food.region!)
                    : availableFoods.map((food) => food.country))
                .toSet()
                .toList()
              ..sort();
        final regionOrCountryDisplayNames = useRegionFilter
            ? {for (final f in availableFoods) f.region!: f.displayRegion!}
            : {for (final f in availableFoods) f.country: f.displayCountry};
        final cookingMethods =
            availableFoods.map((food) => food.cookingMethod).toSet().toList()
              ..sort();
        final cookingMethodDisplayNames = {
          for (final f in availableFoods)
            f.cookingMethod: f.displayCookingMethod,
        };
        final filteredFoods = availableFoods.where((food) {
          final hasSelectedRegionOrCountry =
              selectedRegionOrCountry == _kAllOption ||
              (useRegionFilter ? food.region : food.country) ==
                  selectedRegionOrCountry;
          final hasSelectedCookingMethod =
              selectedCookingMethod == _kAllOption ||
              food.cookingMethod == selectedCookingMethod;
          return hasSelectedRegionOrCountry &&
              hasSelectedCookingMethod &&
              food.matchesQuery(searchController.text);
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
                          'food_dexTitle'.trParams({
                            'count': '${filteredFoods.length}',
                          }),
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
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onChanged: (_) => setModalState(() {}),
                            style: const TextStyle(color: Colors.white),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: 'food_dexSearchHint'.tr,
                              hintStyle: const TextStyle(color: Colors.white54),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white70,
                              ),
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
                          child: Column(
                            children: [
                              _FoodDexFilterDropdown(
                                value: selectedRegionOrCountry,
                                allLabel: useRegionFilter
                                    ? 'food_dexAllRegions'.tr
                                    : 'food_dexAllCountries'.tr,
                                values: regionOrCountryValues,
                                displayNames: regionOrCountryDisplayNames,
                                onChanged: (value) => setModalState(
                                  () => selectedRegionOrCountry = value,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _FoodDexFilterDropdown(
                                value: selectedCookingMethod,
                                allLabel: 'food_dexAllCookingMethods'.tr,
                                values: cookingMethods,
                                displayNames: cookingMethodDisplayNames,
                                onChanged: (value) => setModalState(
                                  () => selectedCookingMethod = value,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                          food.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${food.displayCountry} · ${food.displayDishType} · ${food.displayCookingMethod}',
                          style: const TextStyle(color: Colors.white60),
                        ),
                        onTap: () => Navigator.of(dialogContext).pop(food),
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

/// A single-select filter dropdown used by the food dex (region/country,
/// cooking method, ...) sharing the same "all" + sorted-values shape.
class _FoodDexFilterDropdown extends StatelessWidget {
  const _FoodDexFilterDropdown({
    required this.value,
    required this.allLabel,
    required this.values,
    required this.displayNames,
    required this.onChanged,
  });

  final String value;
  final String allLabel;
  final List<String> values;
  final Map<String, String> displayNames;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      dropdownColor: kFoodPanelColor,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: kFoodBgColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      items: [
        DropdownMenuItem(value: _kAllOption, child: Text(allLabel)),
        ...values.map(
          (v) => DropdownMenuItem(
            value: v,
            child: Text(displayNames[v] ?? v, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
      onChanged: (v) {
        if (v == null) return;
        onChanged(v);
      },
    );
  }
}

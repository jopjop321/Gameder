import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/place.dart';
import '../theme/placedle_theme.dart';

Future<Place?> showPlaceDexDialog(
  BuildContext context,
  List<Place> availablePlaces, {
  bool groupByRegion = false,
}) {
  final searchController = TextEditingController();
  var selectedGroup = 'ทั้งหมด';

  String groupOf(Place place) =>
      groupByRegion ? (place.region ?? '-') : place.country;
  String displayGroupOf(Place place) =>
      groupByRegion ? (place.displayRegion ?? '-') : place.displayCountry;

  return showDialog<Place>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setModalState) {
        final groups = availablePlaces.map(groupOf).toSet().toList()..sort();
        final groupDisplayNames = {
          for (final p in availablePlaces) groupOf(p): displayGroupOf(p),
        };
        final filteredPlaces = availablePlaces.where((place) {
          final hasSelectedGroup =
              selectedGroup == 'ทั้งหมด' || groupOf(place) == selectedGroup;
          return hasSelectedGroup && place.matchesQuery(searchController.text);
        }).toList();

        return Dialog(
          backgroundColor: kPlacePanelColor,
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
                        Icons.map_rounded,
                        color: kPlaceAccentColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'place_dexTitle'.trParams(
                            {'count': '${filteredPlaces.length}'},
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
                        flex: 3,
                        child: TextField(
                          controller: searchController,
                          onChanged: (_) => setModalState(() {}),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'place_dexSearchHint'.tr,
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: kPlaceBgColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: selectedGroup,
                          isExpanded: true,
                          dropdownColor: kPlacePanelColor,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: kPlaceBgColor,
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
                              child: Text(
                                groupByRegion
                                    ? 'place_dexAllRegions'.tr
                                    : 'place_dexAllCountries'.tr,
                              ),
                            ),
                            ...groups.map(
                              (group) => DropdownMenuItem(
                                value: group,
                                child: Text(
                                  groupDisplayNames[group] ?? group,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (group) {
                            if (group == null) return;
                            setModalState(() => selectedGroup = group);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredPlaces.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white12, height: 1),
                    itemBuilder: (context, index) {
                      final place = filteredPlaces[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: kPlaceHeaderCellColor,
                          child: Icon(
                            Icons.place,
                            color: kPlaceAccentColor,
                          ),
                        ),
                        title: Text(
                          place.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${place.displayCountry} · ${place.displayPlaceType} · ${place.displayActivity}',
                          style: const TextStyle(color: Colors.white60),
                        ),
                        onTap: () => Navigator.of(dialogContext).pop(place),
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

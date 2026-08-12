import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/car.dart';
import '../theme/cardle_theme.dart';

Future<Car?> showCarDexDialog(
  BuildContext context,
  List<Car> availableCars,
) {
  final searchController = TextEditingController();
  var selectedBodyType = 'ทั้งหมด';

  return showDialog<Car>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setModalState) {
        final bodyTypes =
            availableCars.map((car) => car.bodyType).toSet().toList()..sort();
        final filteredCars = availableCars.where((car) {
          final hasSelectedBodyType = selectedBodyType == 'ทั้งหมด' ||
              car.bodyType == selectedBodyType;
          return hasSelectedBodyType && car.matchesQuery(searchController.text);
        }).toList();

        return Dialog(
          backgroundColor: kCarPanelColor,
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
                        Icons.directions_car_outlined,
                        color: kCarAccentColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'car_dexTitle'.trParams(
                            {'count': '${filteredCars.length}'},
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
                            hintText: 'car_dexSearchHint'.tr,
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: kCarBgColor,
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
                          value: selectedBodyType,
                          isExpanded: true,
                          dropdownColor: kCarPanelColor,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: kCarBgColor,
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
                              child: Text('car_dexAllBodyTypes'.tr),
                            ),
                            ...bodyTypes.map(
                              (bodyType) => DropdownMenuItem(
                                value: bodyType,
                                child: Text(
                                  bodyType,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (bodyType) {
                            if (bodyType == null) return;
                            setModalState(() => selectedBodyType = bodyType);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredCars.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white12, height: 1),
                    itemBuilder: (context, index) {
                      final car = filteredCars[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: kCarHeaderCellColor,
                          child: Icon(
                            Icons.directions_car_outlined,
                            color: kCarAccentColor,
                          ),
                        ),
                        title: Text(
                          car.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${car.brand} · ${car.bodyType} · ${car.launchYear}',
                          style: const TextStyle(color: Colors.white60),
                        ),
                        onTap: () => Navigator.of(dialogContext).pop(car),
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

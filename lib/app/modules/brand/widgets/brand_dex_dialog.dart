import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/brand.dart';
import '../theme/branddle_theme.dart';

Future<Brand?> showBrandDexDialog(
  BuildContext context,
  List<Brand> availableBrands,
) {
  final searchController = TextEditingController();
  var selectedIndustryGroup = 'ทั้งหมด';

  return showDialog<Brand>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setModalState) {
        final industryGroups =
            availableBrands.map((brand) => brand.industryGroup).toSet().toList()
              ..sort();
        final filteredBrands = availableBrands.where((brand) {
          final hasSelectedIndustryGroup = selectedIndustryGroup == 'ทั้งหมด' ||
              brand.industryGroup == selectedIndustryGroup;
          return hasSelectedIndustryGroup &&
              brand.matchesQuery(searchController.text);
        }).toList();

        return Dialog(
          backgroundColor: kBrandPanelColor,
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
                        Icons.branding_watermark_outlined,
                        color: kBrandAccentColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'brand_dexTitle'.trParams(
                            {'count': '${filteredBrands.length}'},
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
                            hintText: 'brand_dexSearchHint'.tr,
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white70,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: kBrandBgColor,
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
                          value: selectedIndustryGroup,
                          isExpanded: true,
                          dropdownColor: kBrandPanelColor,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: kBrandBgColor,
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
                              child: Text('brand_dexAllIndustries'.tr),
                            ),
                            ...industryGroups.map(
                              (industryGroup) => DropdownMenuItem(
                                value: industryGroup,
                                child: Text(
                                  industryGroup,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (industryGroup) {
                            if (industryGroup == null) return;
                            setModalState(
                              () => selectedIndustryGroup = industryGroup,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredBrands.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white12, height: 1),
                    itemBuilder: (context, index) {
                      final brand = filteredBrands[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: kBrandHeaderCellColor,
                          child: Icon(
                            Icons.branding_watermark_outlined,
                            color: kBrandAccentColor,
                          ),
                        ),
                        title: Text(
                          brand.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${brand.industry} · ${brand.foundedYear}',
                          style: const TextStyle(color: Colors.white60),
                        ),
                        onTap: () => Navigator.of(dialogContext).pop(brand),
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

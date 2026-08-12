import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/car.dart';

class CarService {
  /// Loads cars for [collectionId] from assets/data/cars/{file}.json.
  static Future<List<Car>> loadCars(String collectionId) async {
    final cars = <Car>[];
    for (final file in resolveCollectionFiles(collectionId)) {
      try {
        final raw = await rootBundle.loadString('assets/data/cars/$file.json');
        final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
        cars.addAll(
          jsonList.map((item) => Car.fromJson(item as Map<String, dynamic>)),
        );
      } catch (_) {
        // Skip files that fail to load.
      }
    }
    return cars;
  }

  /// Only one data file currently exists ('all'), so this simply returns
  /// the requested collection id unconditionally.
  static List<String> resolveCollectionFiles(String collectionId) {
    return [collectionId];
  }
}

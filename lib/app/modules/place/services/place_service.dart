import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/place.dart';

class PlaceService {
  /// Loads places for [regionId] from assets/data/place/{regionId}.json.
  /// 'thailand' -> Thai attractions, 'world' -> attractions outside Thailand.
  static Future<List<Place>> loadPlaces(String regionId) async {
    final places = <Place>[];
    try {
      final raw = await rootBundle.loadString('assets/data/place/$regionId.json');
      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      places.addAll(
        jsonList.map((item) => Place.fromJson(item as Map<String, dynamic>)),
      );
    } catch (_) {
      // Skip files that fail to load.
    }
    return places;
  }
}

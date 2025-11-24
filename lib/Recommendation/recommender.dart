import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Recommender {
  Recommender._private();
  static final Recommender instance = Recommender._private();

  late Map<String, dynamic> _data;
  bool _loaded = false;

  Future<void> loadFromAsset(
      [String assetPath = 'assets/recommendations.json']) async {
    if (_loaded) return;
    final s = await rootBundle.loadString(assetPath);
    _data = jsonDecode(s) as Map<String, dynamic>;
    _loaded = true;
  }

  List<int> getRecommendationsFor(int movieId, {int max = 15}) {
    if (!_loaded) return [];
    final key = movieId.toString();
    if (!_data.containsKey(key)) return [];
    final recs = _data[key];
    if (recs is List) {
      return recs.map<int>((e) => int.parse(e.toString())).take(max).toList();
    }
    return [];
  }
}

// lib/favorites_manager.dart
class FavoritesManager {
  static final List<Map<String, dynamic>> favoriteItems = [];

  static bool isFavorite(String id, String type) {
    return favoriteItems
        .any((item) => item['id'] == id && item['type'] == type);
  }

  static void addFavorite(Map<String, dynamic> movie) {
    favoriteItems.add(movie);
  }

  static void removeFavorite(String id, String type) {
    favoriteItems
        .removeWhere((item) => item['id'] == id && item['type'] == type);
  }

  static List<Map<String, dynamic>> getFavorites() {
    return favoriteItems;
  }
}

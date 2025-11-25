// lib/favorite_list_page.dart
import 'package:flutter/material.dart';
//import 'favorites_manager.dart';
import '../favorites_manager.dart';

class FavoriteListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favs = FavoritesManager.getFavorites();

    return Scaffold(
      appBar: AppBar(title: Text("Favorites")),
      body: favs.isEmpty
          ? Center(child: Text("No favorites yet"))
          : ListView.builder(
              itemCount: favs.length,
              itemBuilder: (context, index) {
                final item = favs[index];
                return ListTile(
                  leading: item['image'] != null
                      ? Image.network(
                          "https://image.tmdb.org/t/p/w92${item['image']}",
                          width: 50,
                        )
                      : null,
                  title: Text(item['name']),
                  subtitle: Text("Rating: ${item['rating']}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      FavoritesManager.removeFavorite(item['id'], item['type']);
                      (context as Element).markNeedsBuild(); // rebuild list
                    },
                  ),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';

import '../favorite_store.dart';
import '../widgets/recipe_image.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite')),
      body: ListenableBuilder(
        listenable: FavoriteStore.instance,
        builder: (context, _) {
          final items = FavoriteStore.instance.items;
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada resep favorit'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final r = items[i];
              return Material(
                color: const Color(0xFFD0F0ED),
                elevation: 1,
                borderRadius: BorderRadius.circular(12),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: RecipeImage(
                      url: r.image, width: 56, height: 56, radius: 8),
                  title: Text(r.name),
                  subtitle: Text('${r.cuisine} • ${r.difficulty}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => FavoriteStore.instance.toggle(r),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailPage(id: r.id)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../api_service.dart';
import '../favorite_store.dart';
import '../recipe.dart';
import '../widgets/recipe_image.dart';

class DetailPage extends StatefulWidget {
  final int id;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Recipe> _future;
  Recipe? _recipe;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchDetail(widget.id).then((r) {
      _recipe = r;
      return r;
    });
  }

  Future<void> _toggle() async {
    final r = _recipe;
    if (r == null) return;
    final nowFav = await FavoriteStore.instance.toggle(r);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content:
            Text(nowFav ? 'Ditambahkan ke favorite' : 'Dihapus dari favorite'),
        backgroundColor: const Color(0xFF2E3330),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Resep', style: TextStyle(fontSize: 18)),
        actions: [
          ListenableBuilder(
            listenable: FavoriteStore.instance,
            builder: (_, __) {
              final fav = FavoriteStore.instance.isFavorite(widget.id);
              return IconButton(
                onPressed: _toggle,
                icon: fav
                    ? Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.teal.shade700,
                            borderRadius: BorderRadius.circular(6)),
                        child: const Icon(Icons.favorite,
                            color: Colors.yellow, size: 20),
                      )
                    : const Icon(Icons.favorite_border),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Recipe>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text('${snap.error}',
                      style: const TextStyle(color: Colors.white)),
                  backgroundColor: Colors.red,
                ));
            });
            return const Center(child: Text('Gagal memuat data'));
          }
          final r = snap.data!;
          return ListView(
            children: [
              RecipeImage(url: r.image, width: double.infinity, height: 250),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('${r.cuisine} • ${r.mealType.join(', ')}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _chip(Icons.star, '${r.rating} (${r.reviewCount})'),
                        _chip(Icons.speed, r.difficulty),
                        _chip(Icons.timer_outlined,
                            'Persiapan ${r.prepTimeMinutes} mnt'),
                        _chip(Icons.local_fire_department_outlined,
                            'Masak ${r.cookTimeMinutes} mnt'),
                        _chip(Icons.people_outline, '${r.servings} porsi'),
                        _chip(Icons.bolt, '${r.caloriesPerServing} kal/porsi'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Bahan-bahan',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    for (final b in r.ingredients)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child:
                            Text('• $b', style: const TextStyle(fontSize: 14)),
                      ),
                    const SizedBox(height: 20),
                    const Text('Langkah Memasak',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    for (var i = 0; i < r.instructions.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 11,
                              backgroundColor: const Color(0xFF05C15A),
                              child: Text('${i + 1}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(r.instructions[i],
                                  style: const TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.teal.shade800),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
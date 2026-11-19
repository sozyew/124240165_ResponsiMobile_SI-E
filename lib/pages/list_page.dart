import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_service.dart';
import '../recipe.dart';
import '../widgets/recipe_image.dart';
import 'detail_page.dart';
import 'favorite_page.dart';
import 'login_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late Future<List<Recipe>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchRecipes();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resep Masakan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FavoritePage())),
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: FutureBuilder<List<Recipe>>(
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
            return Center(
              child: FilledButton(
                onPressed: () =>
                    setState(() => _future = ApiService.fetchRecipes()),
                child: const Text('Coba lagi'),
              ),
            );
          }
          final data = snap.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.72,
            ),
            itemCount: data.length,
            itemBuilder: (_, i) => _RecipeCard(recipe: data[i]),
          );
        },
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const _RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFD0F0ED),
      elevation: 1,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(id: recipe.id)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RecipeImage(url: recipe.image, width: double.infinity),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${recipe.cuisine} • ☆ ${recipe.rating}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
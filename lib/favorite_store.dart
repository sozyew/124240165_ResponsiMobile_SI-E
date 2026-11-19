import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'recipe.dart';

class FavoriteStore extends ChangeNotifier {
  FavoriteStore._();
  static final FavoriteStore instance = FavoriteStore._();

  static const _key = 'favorites';
  final Map<int, Recipe> _items = {};

  List<Recipe> get items => _items.values.toList();
  bool isFavorite(int id) => _items.containsKey(id);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    _items.clear();
    for (final s in raw) {
      final r = Recipe.fromJson(jsonDecode(s) as Map<String, dynamic>);
      _items[r.id] = r;
    }
    notifyListeners();
  }

  Future<bool> toggle(Recipe r) async {
    final nowFav = !_items.containsKey(r.id);
    if (nowFav) {
      _items[r.id] = r;
    } else {
      _items.remove(r.id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _key, _items.values.map((e) => jsonEncode(e.toJson())).toList());
    return nowFav;
  }
}
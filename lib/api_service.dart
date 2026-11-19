import 'dart:convert';

import 'package:http/http.dart' as http;

import 'recipe.dart';

class ApiService {
  static const _base = 'https://dummyjson.com/recipes';

  static Future<List<Recipe>> fetchRecipes() async {
    final res = await http
        .get(Uri.parse('$_base?limit=0'))
        .timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat data (${res.statusCode})');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return (data['recipes'] as List)
        .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<Recipe> fetchDetail(int id) async {
    final res = await http
        .get(Uri.parse('$_base/$id'))
        .timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat detail (${res.statusCode})');
    }
    return Recipe.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}
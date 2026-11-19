class Recipe {
  final int id;
  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final String difficulty;
  final String cuisine;
  final int caloriesPerServing;
  final List<String> mealType;
  final String image;
  final double rating;
  final int reviewCount;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.cuisine,
    required this.caloriesPerServing,
    required this.mealType,
    required this.image,
    required this.rating,
    required this.reviewCount,
  });

  factory Recipe.fromJson(Map<String, dynamic> j) => Recipe(
        id: j['id'] ?? 0,
        name: j['name'] ?? '',
        ingredients: List<String>.from(j['ingredients'] ?? []),
        instructions: List<String>.from(j['instructions'] ?? []),
        prepTimeMinutes: j['prepTimeMinutes'] ?? 0,
        cookTimeMinutes: j['cookTimeMinutes'] ?? 0,
        servings: j['servings'] ?? 0,
        difficulty: j['difficulty'] ?? '',
        cuisine: j['cuisine'] ?? '',
        caloriesPerServing: j['caloriesPerServing'] ?? 0,
        mealType: List<String>.from(j['mealType'] ?? []),
        image: j['image'] ?? '',
        rating: (j['rating'] ?? 0).toDouble(),
        reviewCount: j['reviewCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'ingredients': ingredients,
        'instructions': instructions,
        'prepTimeMinutes': prepTimeMinutes,
        'cookTimeMinutes': cookTimeMinutes,
        'servings': servings,
        'difficulty': difficulty,
        'cuisine': cuisine,
        'caloriesPerServing': caloriesPerServing,
        'mealType': mealType,
        'image': image,
        'rating': rating,
        'reviewCount': reviewCount,
      };
}
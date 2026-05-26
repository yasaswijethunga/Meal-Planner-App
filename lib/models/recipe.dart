class RecipeSummary {
  final String id;
  final String name;
  final String thumbnailUrl;

  const RecipeSummary({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
  });

  factory RecipeSummary.fromJson(Map<String, dynamic> json) {
    return RecipeSummary(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      thumbnailUrl: json['strMealThumb'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'idMeal': id,
        'strMeal': name,
        'strMealThumb': thumbnailUrl,
      };
}

class Recipe {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnailUrl;
  final String youtubeUrl;
  final List<Ingredient> ingredients;
  final int ecoScore;

  const Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnailUrl,
    required this.youtubeUrl,
    required this.ingredients,
    required this.ecoScore,
  });

  factory Recipe.fromJson(Map<String, dynamic> json, {int ecoScore = 3}) {
    final ingredients = <Ingredient>[];
    for (int i = 1; i <= 20; i++) {
      final name = (json['strIngredient$i'] as String?) ?? '';
      final measure = (json['strMeasure$i'] as String?) ?? '';
      if (name.trim().isNotEmpty) {
        ingredients.add(Ingredient(name: name.trim(), measure: measure.trim()));
      }
    }
    return Recipe(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      category: (json['strCategory'] as String?) ?? '',
      area: (json['strArea'] as String?) ?? '',
      instructions: (json['strInstructions'] as String?) ?? '',
      thumbnailUrl: (json['strMealThumb'] as String?) ?? '',
      youtubeUrl: (json['strYoutube'] as String?) ?? '',
      ingredients: ingredients,
      ecoScore: ecoScore,
    );
  }

  Map<String, dynamic> toJson() => {
        'idMeal': id,
        'strMeal': name,
        'strCategory': category,
        'strArea': area,
        'strInstructions': instructions,
        'strMealThumb': thumbnailUrl,
        'strYoutube': youtubeUrl,
        'ecoScore': ecoScore,
      };
}

class Ingredient {
  final String name;
  final String measure;

  const Ingredient({required this.name, required this.measure});
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeService {
  static const _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static const List<String> ecoCategories = [
    'Vegan',
    'Vegetarian',
    'Pasta',
    'Starter',
    'Seafood',
  ];

  static const Map<String, int> _categoryEcoScores = {
    'Vegan': 5,
    'Vegetarian': 4,
    'Pasta': 4,
    'Starter': 3,
    'Seafood': 3,
    'Breakfast': 3,
    'Dessert': 3,
    'Side': 3,
    'Miscellaneous': 3,
    'Chicken': 2,
    'Pork': 2,
    'Goat': 2,
    'Lamb': 1,
    'Beef': 1,
  };

  int ecoScoreForCategory(String category) =>
      _categoryEcoScores[category] ?? 3;

  Future<List<RecipeSummary>> fetchRecipesByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/filter.php?c=$category'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load recipes (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = data['meals'] as List<dynamic>? ?? [];
    return meals
        .map((m) => RecipeSummary.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  Future<Recipe> fetchRecipeById(String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/lookup.php?i=$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load recipe (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = data['meals'] as List<dynamic>?;
    if (meals == null || meals.isEmpty) throw Exception('Recipe not found');
    final mealData = meals.first as Map<String, dynamic>;
    final category = (mealData['strCategory'] as String?) ?? '';
    return Recipe.fromJson(mealData, ecoScore: ecoScoreForCategory(category));
  }

  Future<List<RecipeSummary>> searchRecipes(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search.php?s=${Uri.encodeComponent(query)}'),
    );
    if (response.statusCode != 200) {
      throw Exception('Search failed (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = data['meals'] as List<dynamic>? ?? [];
    return meals
        .map((m) => RecipeSummary.fromJson(m as Map<String, dynamic>))
        .toList();
  }
}

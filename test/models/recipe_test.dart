import 'package:ecoplate/models/recipe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RecipeSummary', () {
    final sampleJson = {
      'idMeal': '52772',
      'strMeal': 'Teriyaki Chicken Casserole',
      'strMealThumb': 'https://example.com/thumb.jpg',
    };

    test('fromJson creates correct instance', () {
      final recipe = RecipeSummary.fromJson(sampleJson);
      expect(recipe.id, '52772');
      expect(recipe.name, 'Teriyaki Chicken Casserole');
      expect(recipe.thumbnailUrl, 'https://example.com/thumb.jpg');
    });

    test('toJson round-trips correctly', () {
      final recipe = RecipeSummary.fromJson(sampleJson);
      final json = recipe.toJson();
      expect(json['idMeal'], recipe.id);
      expect(json['strMeal'], recipe.name);
      expect(json['strMealThumb'], recipe.thumbnailUrl);
    });

    test('fromJson then toJson preserves data', () {
      final original = RecipeSummary.fromJson(sampleJson);
      final restored = RecipeSummary.fromJson(original.toJson());
      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.thumbnailUrl, original.thumbnailUrl);
    });
  });

  group('Recipe', () {
    final detailJson = {
      'idMeal': '52772',
      'strMeal': 'Teriyaki Chicken Casserole',
      'strCategory': 'Chicken',
      'strArea': 'Japanese',
      'strInstructions': 'Mix and bake at 180°C for 30 minutes.',
      'strMealThumb': 'https://example.com/thumb.jpg',
      'strYoutube': 'https://youtube.com/watch?v=abc',
      'strIngredient1': 'Chicken',
      'strMeasure1': '500g',
      'strIngredient2': 'Teriyaki Sauce',
      'strMeasure2': '3 tbsp',
      'strIngredient3': '',
      'strMeasure3': '',
    };

    test('fromJson parses basic fields', () {
      final recipe = Recipe.fromJson(detailJson, ecoScore: 2);
      expect(recipe.id, '52772');
      expect(recipe.name, 'Teriyaki Chicken Casserole');
      expect(recipe.category, 'Chicken');
      expect(recipe.area, 'Japanese');
      expect(recipe.ecoScore, 2);
    });

    test('fromJson filters empty ingredients', () {
      final recipe = Recipe.fromJson(detailJson);
      expect(recipe.ingredients.length, 2);
      expect(recipe.ingredients[0].name, 'Chicken');
      expect(recipe.ingredients[0].measure, '500g');
      expect(recipe.ingredients[1].name, 'Teriyaki Sauce');
    });

    test('toJson includes all key fields', () {
      final recipe = Recipe.fromJson(detailJson, ecoScore: 3);
      final json = recipe.toJson();
      expect(json['idMeal'], '52772');
      expect(json['strMeal'], 'Teriyaki Chicken Casserole');
      expect(json['ecoScore'], 3);
    });

    test('fromJson handles missing optional fields gracefully', () {
      final minimalJson = {
        'idMeal': '1',
        'strMeal': 'Test Meal',
        'strMealThumb': 'https://example.com/img.jpg',
      };
      final recipe = Recipe.fromJson(minimalJson);
      expect(recipe.category, '');
      expect(recipe.area, '');
      expect(recipe.instructions, '');
      expect(recipe.ingredients, isEmpty);
    });
  });
}

import 'package:ecoplate/services/recipe_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RecipeService service;

  setUp(() => service = RecipeService());

  group('RecipeService.ecoScoreForCategory', () {
    test('returns 5 for Vegan', () {
      expect(service.ecoScoreForCategory('Vegan'), 5);
    });

    test('returns 4 for Vegetarian', () {
      expect(service.ecoScoreForCategory('Vegetarian'), 4);
    });

    test('returns 4 for Pasta', () {
      expect(service.ecoScoreForCategory('Pasta'), 4);
    });

    test('returns 3 for Seafood', () {
      expect(service.ecoScoreForCategory('Seafood'), 3);
    });

    test('returns 1 for Beef', () {
      expect(service.ecoScoreForCategory('Beef'), 1);
    });

    test('returns 1 for Lamb', () {
      expect(service.ecoScoreForCategory('Lamb'), 1);
    });

    test('returns default 3 for unknown category', () {
      expect(service.ecoScoreForCategory('Unknown'), 3);
    });
  });

  group('RecipeService.ecoCategories', () {
    test('contains expected eco-friendly categories', () {
      expect(RecipeService.ecoCategories, contains('Vegan'));
      expect(RecipeService.ecoCategories, contains('Vegetarian'));
      expect(RecipeService.ecoCategories, contains('Pasta'));
    });

    test('does not contain high-carbon categories', () {
      expect(RecipeService.ecoCategories, isNot(contains('Beef')));
      expect(RecipeService.ecoCategories, isNot(contains('Lamb')));
    });
  });
}

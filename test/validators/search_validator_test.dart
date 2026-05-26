import 'package:ecoplate/validators/search_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateSearch', () {
    test('returns error for null input', () {
      expect(validateSearch(null), isNotNull);
    });

    test('returns error for empty string', () {
      expect(validateSearch(''), isNotNull);
    });

    test('returns error for whitespace-only string', () {
      expect(validateSearch('   '), isNotNull);
    });

    test('returns error for single character', () {
      expect(validateSearch('a'), isNotNull);
    });

    test('returns null for valid two-character query', () {
      expect(validateSearch('ab'), isNull);
    });

    test('returns null for typical search term', () {
      expect(validateSearch('pasta'), isNull);
    });

    test('returns null for search term with spaces', () {
      expect(validateSearch('chicken soup'), isNull);
    });

    test('returns null for search term with hyphen', () {
      expect(validateSearch('stir-fry'), isNull);
    });

    test('returns error for string exceeding 50 characters', () {
      final longQuery = 'a' * 51;
      expect(validateSearch(longQuery), isNotNull);
    });

    test('returns null for exactly 50 characters', () {
      final maxQuery = 'a' * 50;
      expect(validateSearch(maxQuery), isNull);
    });

    test('returns error for query with special characters', () {
      expect(validateSearch('pasta!@#'), isNotNull);
    });

    test('returns error for query with emoji', () {
      expect(validateSearch('pasta🍝'), isNotNull);
    });
  });
}

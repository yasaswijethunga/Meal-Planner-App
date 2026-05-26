import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal_plan.dart';
import '../models/recipe.dart';
import 'shared_preferences_provider.dart';

class MealPlanNotifier extends Notifier<MealPlan> {
  static const _key = 'meal_plan';

  @override
  MealPlan build() => _load();

  MealPlan _load() {
    final prefs = ref.read(sharedPreferencesProvider);
    final json = prefs.getString(_key);
    if (json == null) return MealPlan.empty();
    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      final days = <String, RecipeSummary?>{};
      for (final day in MealPlan.weekDays) {
        final entry = data[day];
        days[day] =
            entry != null ? RecipeSummary.fromJson(entry as Map<String, dynamic>) : null;
      }
      return MealPlan(days: days);
    } catch (_) {
      return MealPlan.empty();
    }
  }

  Future<void> setRecipe(String day, RecipeSummary? recipe) async {
    state = state.withRecipe(day, recipe);
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final data = {
      for (final e in state.days.entries) e.key: e.value?.toJson(),
    };
    await prefs.setString(_key, jsonEncode(data));
  }
}

final mealPlanProvider =
    NotifierProvider<MealPlanNotifier, MealPlan>(MealPlanNotifier.new);

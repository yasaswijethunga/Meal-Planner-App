import 'recipe.dart';

class MealPlan {
  final Map<String, RecipeSummary?> days;

  const MealPlan({required this.days});

  static const List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static MealPlan empty() {
    return MealPlan(days: {for (final day in weekDays) day: null});
  }

  MealPlan withRecipe(String day, RecipeSummary? recipe) {
    return MealPlan(days: {...days, day: recipe});
  }
}

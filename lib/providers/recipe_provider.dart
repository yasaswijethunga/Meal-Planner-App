import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

final recipeServiceProvider = Provider<RecipeService>((ref) => RecipeService());

final ecoCategoriesProvider = Provider<List<String>>(
  (ref) => RecipeService.ecoCategories,
);

class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'Vegetarian';

  void select(String category) => state = category;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String>(
  SelectedCategoryNotifier.new,
);

class RecipeListNotifier extends AsyncNotifier<List<RecipeSummary>> {
  static const _pageSize = 10;
  List<RecipeSummary> _all = [];
  List<RecipeSummary> _displayed = [];

  @override
  Future<List<RecipeSummary>> build() async {
    final category = ref.watch(selectedCategoryProvider);
    final service = ref.read(recipeServiceProvider);
    _all = await service.fetchRecipesByCategory(category);
    _displayed = _all.take(_pageSize).toList();
    return _displayed;
  }

  bool get hasMore => _displayed.length < _all.length;

  Future<void> loadMore() async {
    if (!hasMore) return;
    _displayed = _all.take(_displayed.length + _pageSize).toList();
    state = AsyncData(_displayed);
  }

  void retry() => ref.invalidateSelf();
}

final recipeListProvider =
    AsyncNotifierProvider<RecipeListNotifier, List<RecipeSummary>>(
  RecipeListNotifier.new,
);

final recipeDetailProvider =
    FutureProvider.autoDispose.family<Recipe, String>((ref, id) async {
  return ref.read(recipeServiceProvider).fetchRecipeById(id);
});

final searchResultsProvider = FutureProvider.autoDispose
    .family<List<RecipeSummary>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  return ref.read(recipeServiceProvider).searchRecipes(query);
});

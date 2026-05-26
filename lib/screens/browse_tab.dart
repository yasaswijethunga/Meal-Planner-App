import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';

class BrowseTab extends ConsumerStatefulWidget {
  const BrowseTab({super.key});

  @override
  ConsumerState<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends ConsumerState<BrowseTab> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final notifier = ref.read(recipeListProvider.notifier);
      if (notifier.hasMore) notifier.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(ecoCategoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final recipesAsync = ref.watch(recipeListProvider);
    final service = ref.read(recipeServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoPlate'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          _CategoryFilter(categories: categories, selected: selectedCategory),
          Expanded(
            child: recipesAsync.when(
              data: (recipes) => _RecipeList(
                recipes: recipes,
                ecoScore: service.ecoScoreForCategory(selectedCategory),
                scrollController: _scrollController,
                notifier: ref.read(recipeListProvider.notifier),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _ErrorView(
                message: error.toString(),
                onRetry: () => ref.read(recipeListProvider.notifier).retry(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilter extends ConsumerWidget {
  final List<String> categories;
  final String selected;

  const _CategoryFilter({required this.categories, required this.selected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 56,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: category == selected,
              onSelected: (_) {
                ref.read(selectedCategoryProvider.notifier).select(category);
              },
            ),
          );
        },
      ),
    );
  }
}

class _RecipeList extends StatelessWidget {
  final List<RecipeSummary> recipes;
  final int ecoScore;
  final ScrollController scrollController;
  final RecipeListNotifier notifier;

  const _RecipeList({
    required this.recipes,
    required this.ecoScore,
    required this.scrollController,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) {
      return const Center(child: Text('No recipes found for this category'));
    }
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: recipes.length + (notifier.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == recipes.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final recipe = recipes[index];
        return RecipeCard(
          recipe: recipe,
          ecoScore: ecoScore,
          onTap: () => context.push('/recipe/${recipe.id}'),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recipe_provider.dart';
import '../widgets/eco_badge.dart';
import '../widgets/ingredient_tile.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final String id;

  const RecipeDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeAsync = ref.watch(recipeDetailProvider(id));
    return recipeAsync.when(
      data: (recipe) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 14,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                background: CachedNetworkImage(
                  imageUrl: recipe.thumbnailUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) =>
                      Container(color: Colors.grey.shade300),
                  errorWidget: (_, _, _) =>
                      const Icon(Icons.broken_image, size: 64),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      children: [
                        Chip(
                          label: Text(recipe.category),
                          avatar: const Icon(Icons.category, size: 16),
                        ),
                        if (recipe.area.isNotEmpty)
                          Chip(
                            label: Text(recipe.area),
                            avatar: const Icon(Icons.place, size: 16),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    EcoBadge(score: recipe.ecoScore),
                    const Divider(height: 32),
                    Text(
                      'Ingredients',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ...recipe.ingredients.map(
                      (i) => IngredientTile(ingredient: i),
                    ),
                    const Divider(height: 32),
                    Text(
                      'Instructions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      recipe.instructions,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                          ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                Text(error.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => ref.refresh(recipeDetailProvider(id)),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

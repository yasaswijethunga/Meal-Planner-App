import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/meal_plan.dart';
import '../models/recipe.dart';
import '../providers/meal_plan_provider.dart';
import '../providers/recipe_provider.dart';
import '../validators/search_validator.dart';

class MealPlannerScreen extends ConsumerWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(mealPlanProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Meal Planner')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: MealPlan.weekDays.length,
        itemBuilder: (context, index) {
          final day = MealPlan.weekDays[index];
          final recipe = plan.days[day];
          return _DayCard(
            day: day,
            recipe: recipe,
            onAdd: () => _showPicker(context, ref, day),
            onRemove: () =>
                ref.read(mealPlanProvider.notifier).setRecipe(day, null),
            onTap: recipe != null
                ? () => context.push('/recipe/${recipe.id}')
                : null,
          );
        },
      ),
    );
  }

  Future<void> _showPicker(
      BuildContext context, WidgetRef ref, String day) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _RecipePickerSheet(day: day),
    );
  }
}

class _DayCard extends StatelessWidget {
  final String day;
  final RecipeSummary? recipe;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback? onTap;

  const _DayCard({
    required this.day,
    required this.recipe,
    required this.onAdd,
    required this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _DayAvatar(day: day),
        title: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: recipe != null
            ? GestureDetector(
                onTap: onTap,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: recipe!.thumbnailUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) =>
                            const Icon(Icons.broken_image),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recipe!.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            : const Text('No meal planned',
                style: TextStyle(color: Colors.grey)),
        trailing: recipe != null
            ? IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: onRemove,
                tooltip: 'Remove',
              )
            : IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: onAdd,
                tooltip: 'Add meal',
              ),
      ),
    );
  }
}

class _DayAvatar extends StatelessWidget {
  final String day;

  const _DayAvatar({required this.day});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Text(
        day.substring(0, 2),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _RecipePickerSheet extends ConsumerStatefulWidget {
  final String day;

  const _RecipePickerSheet({required this.day});

  @override
  ConsumerState<_RecipePickerSheet> createState() => _RecipePickerSheetState();
}

class _RecipePickerSheetState extends ConsumerState<_RecipePickerSheet> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    if (_formKey.currentState!.validate()) {
      setState(() => _query = _controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                'Add meal for ${widget.day}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _controller,
                  validator: validateSearch,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (_) => _search(),
                  decoration: InputDecoration(
                    hintText: 'Search recipes...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: _search,
                    ),
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _query.isEmpty
                  ? const Center(child: Text('Search to find recipes'))
                  : _PickerResults(
                      query: _query,
                      day: widget.day,
                      scrollController: scrollController,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerResults extends ConsumerWidget {
  final String query;
  final String day;
  final ScrollController scrollController;

  const _PickerResults({
    required this.query,
    required this.day,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(searchResultsProvider(query));
    return resultsAsync.when(
      data: (recipes) {
        if (recipes.isEmpty) {
          return const Center(child: Text('No results found'));
        }
        return ListView.builder(
          controller: scrollController,
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: recipe.thumbnailUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => const Icon(Icons.broken_image),
                ),
              ),
              title: Text(recipe.name),
              onTap: () {
                ref
                    .read(mealPlanProvider.notifier)
                    .setRecipe(day, recipe);
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text(error.toString())),
    );
  }
}

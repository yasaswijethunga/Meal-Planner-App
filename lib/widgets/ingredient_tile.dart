import 'package:flutter/material.dart';
import '../models/recipe.dart';

class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;

  const IngredientTile({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.restaurant_menu, size: 18),
      title: Text(ingredient.name),
      trailing: ingredient.measure.isNotEmpty
          ? Text(
              ingredient.measure,
              style: Theme.of(context).textTheme.bodySmall,
            )
          : null,
    );
  }
}

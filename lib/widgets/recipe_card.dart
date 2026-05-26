import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'eco_badge.dart';

class RecipeCard extends StatelessWidget {
  final RecipeSummary recipe;
  final int? ecoScore;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    this.ecoScore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: recipe.thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, size: 48),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (ecoScore != null) ...[
                    const SizedBox(height: 6),
                    EcoBadge(score: ecoScore!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

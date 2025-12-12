import 'package:flutter/material.dart';

import '../../models/meal.dart';
import '../../services/favorites_service.dart';

/// Grid card widget to display a meal (image + name).
class MealCard extends StatefulWidget {
  const MealCard({
    Key? key,
    required this.meal,
    this.onTap,
  }) : super(key: key);

  final Meal meal;
  final VoidCallback? onTap;

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  late FavoritesService _favoritesService;

  @override
  void initState() {
    super.initState();
    _favoritesService = FavoritesService();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image
                Expanded(
                  child: _buildImage(),
                ),
                // Name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.meal.name,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            // Favorite button
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _favoritesService.toggleFavorite(widget.meal);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    _favoritesService.isFavorite(widget.meal)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final thumb = widget.meal.thumbnail;
    if (thumb != null && thumb.isNotEmpty) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4.0),
          topRight: Radius.circular(4.0),
        ),
        child: Image.network(
          thumb,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => _placeholder(),
          loadingBuilder: (c, child, progress) {
            if (progress == null) return child;
            return Center(
              child: CircularProgressIndicator(strokeWidth: 2.0),
            );
          },
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Icon(Icons.image, size: 32, color: Colors.grey),
    );
  }
}

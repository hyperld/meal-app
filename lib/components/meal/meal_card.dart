import 'package:flutter/material.dart';

import '../../models/meal.dart';

/// Grid card widget to display a meal (image + name).
class MealCard extends StatelessWidget {
  const MealCard({
    Key? key,
    required this.meal,
    this.onTap,
  }) : super(key: key);

  final Meal meal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
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
                meal.name,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final thumb = meal.thumbnail;
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

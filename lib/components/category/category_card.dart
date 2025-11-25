import 'package:flutter/material.dart';

import '../../models/category.dart';

/// Minimal CategoryCard: shows thumbnail, name and short description.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.category,
    this.onTap,
  }) : super(key: key);

  final Category category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: ListTile(
        onTap: onTap,
        leading: _buildAvatar(),
        title: Text(
          category.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: category.description.isNotEmpty
            ? Text(
                category.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildAvatar() {
    final thumb = category.thumbnail;
    if (thumb != null && thumb.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(thumb),
      );
    }
    return const CircleAvatar(child: Icon(Icons.image));
  }
}

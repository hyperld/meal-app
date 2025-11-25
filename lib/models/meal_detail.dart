/// Ingredient with name and measure
class Ingredient {
  final String name;
  final String measure;

  const Ingredient({
    required this.name,
    required this.measure,
  });
}

/// Full meal details from TheMealDB API (lookup.php?i={id})
class MealDetail {
  final String id;
  final String name;
  final String? image;
  final String instructions;
  final List<Ingredient> ingredients;
  final String? youtubeLink;
  final String? category;
  final String? area;

  const MealDetail({
    required this.id,
    required this.name,
    this.image,
    required this.instructions,
    required this.ingredients,
    this.youtubeLink,
    this.category,
    this.area,
  });
}

/// Model for Meal from TheMealDB API
class Meal {
  /// Meal ID from API (idMeal)
  final String id;

  /// Meal name (strMeal)
  final String name;

  /// Meal thumbnail image URL (strMealThumb)
  final String? thumbnail;

  const Meal({
    required this.id,
    required this.name,
    this.thumbnail,
  });
}

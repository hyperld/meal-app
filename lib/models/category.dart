/// Model for Meal Categories from TheMealDB API
/// Fields (from API):
/// - `idCategory` -> `id` (String)
/// - `strCategory` -> `name` (String)
/// - `strCategoryThumb` -> `thumbnail` (String?)
/// - `strCategoryDescription` -> `description` (String)

class Category {
  final String id;
  final String name;
  final String? thumbnail;
  final String description;

  const Category({
    required this.id,
    required this.name,
    this.thumbnail,
    required this.description,
  });
}

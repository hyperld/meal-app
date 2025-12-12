import '../models/meal.dart';

class FavoritesService {
  static final FavoritesService _instance = FavoritesService._internal();
  final List<Meal> _favorites = [];

  factory FavoritesService() {
    return _instance;
  }

  FavoritesService._internal();

  List<Meal> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Meal meal) {
    return _favorites.any((m) => m.id == meal.id);
  }

  void toggleFavorite(Meal meal) {
    if (isFavorite(meal)) {
      _favorites.removeWhere((m) => m.id == meal.id);
    } else {
      _favorites.add(meal);
    }
  }

  void addFavorite(Meal meal) {
    if (!isFavorite(meal)) {
      _favorites.add(meal);
    }
  }

  void removeFavorite(Meal meal) {
    _favorites.removeWhere((m) => m.id == meal.id);
  }
}

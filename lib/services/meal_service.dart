import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

/// Service for fetching meal data from TheMealDB API.
class MealService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  /// Fetch all meal categories.
  /// Throws an exception if the request fails or the response is invalid.
  Future<List<Category>> fetchCategories() async {
    try {
      final resp = await http.get(Uri.parse('$_baseUrl/categories.php'));

      if (resp.statusCode != 200) {
        throw Exception('HTTP ${resp.statusCode}');
      }

      final Map<String, dynamic> data = json.decode(resp.body) as Map<String, dynamic>;
      final raw = data['categories'];

      if (raw is! List) {
        throw Exception('Invalid response format');
      }

      final list = raw.cast<Map<String, dynamic>>();
      return list
          .map((j) => Category(
                id: (j['idCategory'] ?? '').toString(),
                name: (j['strCategory'] ?? '').toString(),
                thumbnail: (j['strCategoryThumb'] ?? '').toString(),
                description: (j['strCategoryDescription'] ?? '').toString(),
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch meals by category.
  /// Endpoint: /filter.php?c={category}
  Future<List<Meal>> fetchMealsByCategory(String category) async {
    try {
      final resp = await http.get(Uri.parse('$_baseUrl/filter.php?c=$category'));

      if (resp.statusCode != 200) {
        throw Exception('HTTP ${resp.statusCode}');
      }

      final Map<String, dynamic> data = json.decode(resp.body) as Map<String, dynamic>;
      final raw = data['meals'];

      if (raw is! List) {
        return [];
      }

      final list = raw.cast<Map<String, dynamic>>();
      return list
          .map((j) => Meal(
                id: (j['idMeal'] ?? '').toString(),
                name: (j['strMeal'] ?? '').toString(),
                thumbnail: (j['strMealThumb'] ?? '').toString(),
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Search meals by query string.
  /// Endpoint: /search.php?s={query}
  Future<List<Meal>> searchMeals(String query) async {
    try {
      final resp = await http.get(Uri.parse('$_baseUrl/search.php?s=$query'));

      if (resp.statusCode != 200) {
        throw Exception('HTTP ${resp.statusCode}');
      }

      final Map<String, dynamic> data = json.decode(resp.body) as Map<String, dynamic>;
      final raw = data['meals'];

      if (raw is! List) {
        return [];
      }

      final list = raw.cast<Map<String, dynamic>>();
      return list
          .map((j) => Meal(
                id: (j['idMeal'] ?? '').toString(),
                name: (j['strMeal'] ?? '').toString(),
                thumbnail: (j['strMealThumb'] ?? '').toString(),
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch detailed meal info by meal ID.
  /// Endpoint: /lookup.php?i={id}
  Future<MealDetail> fetchMealDetail(String mealId) async {
    try {
      final resp = await http.get(Uri.parse('$_baseUrl/lookup.php?i=$mealId'));

      if (resp.statusCode != 200) {
        throw Exception('HTTP ${resp.statusCode}');
      }

      final Map<String, dynamic> data = json.decode(resp.body) as Map<String, dynamic>;
      final raw = data['meals'];

      if (raw is! List || raw.isEmpty) {
        throw Exception('Meal not found');
      }

      final meal = raw[0] as Map<String, dynamic>;
      return _parseMealDetail(meal);
    } catch (e) {
      rethrow;
    }
  }

  /// Helper to parse meal detail from JSON
  MealDetail _parseMealDetail(Map<String, dynamic> json) {
    final ingredients = <Ingredient>[];

    // Parse ingredients and measures from the API response
    // The API returns strIngredient1, strIngredient2, ... strMeasure1, strMeasure2, ...
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'] as String?;
      final measure = json['strMeasure$i'] as String?;

      if ((ingredient ?? '').isNotEmpty && (measure ?? '').isNotEmpty) {
        ingredients.add(Ingredient(
          name: ingredient!,
          measure: measure!,
        ));
      }
    }

    return MealDetail(
      id: (json['idMeal'] ?? '').toString(),
      name: (json['strMeal'] ?? '').toString(),
      image: json['strMealThumb'] as String?,
      instructions: (json['strInstructions'] ?? '').toString(),
      ingredients: ingredients,
      youtubeLink: json['strYoutube'] as String?,
      category: json['strCategory'] as String?,
      area: json['strArea'] as String?,
    );
  }

  /// Fetch a random meal.
  /// Endpoint: /random.php
  Future<MealDetail> fetchRandomMeal() async {
    try {
      final resp = await http.get(Uri.parse('$_baseUrl/random.php'));

      if (resp.statusCode != 200) {
        throw Exception('HTTP ${resp.statusCode}');
      }

      final Map<String, dynamic> data = json.decode(resp.body) as Map<String, dynamic>;
      final raw = data['meals'];

      if (raw is! List || raw.isEmpty) {
        throw Exception('No meal found');
      }

      final meal = raw[0] as Map<String, dynamic>;
      return _parseMealDetail(meal);
    } catch (e) {
      rethrow;
    }
  }
}

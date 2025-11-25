import 'package:flutter/material.dart';

import '../services/meal_service.dart';
import '../screens/meal_detail_screen.dart';

/// Button with dice icon that fetches and displays a random meal.
class RandomMealButton extends StatefulWidget {
  const RandomMealButton({Key? key}) : super(key: key);

  @override
  State<RandomMealButton> createState() => _RandomMealButtonState();
}

class _RandomMealButtonState extends State<RandomMealButton> {
  final _mealService = MealService();
  bool _loading = false;

  Future<void> _fetchAndNavigateToRandom() async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    try {
      final meal = await _mealService.fetchRandomMeal();
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MealDetailScreen(mealId: meal.id),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Грешка: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _loading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.0),
            )
          : const Icon(Icons.casino), // Dice icon
      tooltip: 'Случајна рецепта',
      onPressed: _fetchAndNavigateToRandom,
    );
  }
}

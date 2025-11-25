import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../components/meal/meal_card.dart';
import '../services/meal_service.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  final String category;

  const MealsScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final _mealService = MealService();
  List<Meal> _all = [];
  List<Meal> _filtered = [];
  bool _loading = false;
  String _error = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMeals();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filtered = List.of(_all);
      } else {
        _filtered = _all.where((m) => m.name.toLowerCase().contains(query)).toList();
      }
    });
  }

  Future<void> _fetchMeals() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      _all = await _mealService.fetchMealsByCategory(widget.category);
      _filtered = List.of(_all);
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _searchMeals(String query) async {
    if (query.isEmpty) {
      _fetchMeals();
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      _all = await _mealService.searchMeals(query);
      _filtered = List.of(_all);
    } catch (e) {
      _error = e.toString();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  if (query.isNotEmpty) {
                    _searchMeals(query);
                  } else {
                    _fetchMeals();
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Пребарај јадења',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _fetchMeals();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
            ),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Грешка: $_error', textAlign: TextAlign.center),
              const SizedBox(height: 12.0),
              ElevatedButton(onPressed: _fetchMeals, child: const Text('Обиди повторно')),
            ],
          ),
        ),
      );
    }

    if (_filtered.isEmpty) {
      return const Center(child: Text('Нема резултати'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: _filtered.length,
      itemBuilder: (context, index) {
        final meal = _filtered[index];
        return MealCard(
          meal: meal,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MealDetailScreen(mealId: meal.id),
              ),
            );
          },
        );
      },
    );
  }
}

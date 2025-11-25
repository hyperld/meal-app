import 'package:flutter/material.dart';

import '../models/category.dart';
import '../components/category/category_card.dart';
import '../components/random_meal_button.dart';
import '../services/meal_service.dart';
import 'meals_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _mealService = MealService();
  List<Category> _all = [];
  List<Category> _filtered = [];
  bool _loading = false;
  String _error = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
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
        _filtered = _all.where((c) => c.name.toLowerCase().contains(query)).toList();
      }
    });
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      _all = await _mealService.fetchCategories();
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
        title: const Text('Категории на јадења'),
        centerTitle: true,
        actions: const [RandomMealButton()],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Пребарај категории',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
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
              ElevatedButton(onPressed: _fetchCategories, child: const Text('Обиди повторно')),
            ],
          ),
        ),
      );
    }

    if (_filtered.isEmpty) {
      return const Center(child: Text('Нема резултати'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: _filtered.length,
      itemBuilder: (context, index) {
        final cat = _filtered[index];
        return CategoryCard(
          category: cat,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MealsScreen(category: cat.name),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/meal_detail.dart';
import '../services/meal_service.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({
    Key? key,
    required this.mealId,
  }) : super(key: key);

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final _mealService = MealService();
  MealDetail? _meal;
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadMealDetail();
  }

  Future<void> _loadMealDetail() async {
    try {
      final meal = await _mealService.fetchMealDetail(widget.mealId);
      if (mounted) {
        setState(() {
          _meal = meal;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _openYouTube() async {
    if (_meal?.youtubeLink == null || _meal!.youtubeLink!.isEmpty) return;

    final uri = Uri.parse(_meal!.youtubeLink!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Учитување...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error.isNotEmpty || _meal == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Грешка')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Грешка: $_error', textAlign: TextAlign.center),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  onPressed: _loadMealDetail,
                  child: const Text('Обиди повторно'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final meal = _meal!;

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (meal.image != null && meal.image!.isNotEmpty)
              Image.network(
                meal.image!,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image, size: 64, color: Colors.grey),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Area
                  if (meal.category != null || meal.area != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        children: [
                          if (meal.category != null)
                            Chip(label: Text(meal.category!)),
                          const SizedBox(width: 8.0),
                          if (meal.area != null) Chip(label: Text(meal.area!)),
                        ],
                      ),
                    ),

                  // YouTube Button
                  if (meal.youtubeLink != null && meal.youtubeLink!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ElevatedButton.icon(
                        onPressed: _openYouTube,
                        icon: const Icon(Icons.play_circle),
                        label: const Text('Гледај на YouTube'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),

                  // Instructions
                  Text(
                    'Инструкции',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    meal.instructions,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24.0),

                  // Ingredients
                  Text(
                    'Состојки (${meal.ingredients.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: meal.ingredients.length,
                    itemBuilder: (context, index) {
                      final ing = meal.ingredients[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(ing.name),
                            ),
                            Text(
                              ing.measure,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

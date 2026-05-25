import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/recipe_model.dart';

class RecipesProvider extends ChangeNotifier {
  List<RecipeModel> _recipes = [];
  bool _isLoading = false;

  List<RecipeModel> get recipes => _recipes;
  bool get isLoading => _isLoading;

  Future<void> loadRecipes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await rootBundle.loadString('assets/content/recipes.json');
      final list = json.decode(data) as List;
      _recipes = list.map((e) => RecipeModel.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      _recipes = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}

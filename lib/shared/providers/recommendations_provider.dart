import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/recommendation_model.dart';

class RecommendationsProvider extends ChangeNotifier {
  List<RecommendationModel> _recommendations = [];
  bool _isLoading = false;
  String _selectedCategory = 'todas';

  List<RecommendationModel> get recommendations => _filtered;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  final List<String> categories = [
    'todas',
    'alimentacion',
    'ejercicio',
    'hidratacion',
    'bienestar',
  ];

  List<RecommendationModel> get _filtered {
    if (_selectedCategory == 'todas') return _recommendations;
    return _recommendations
        .where((r) => r.category == _selectedCategory)
        .toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadForCondition(String condition) async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<RecommendationModel> result = [];

      if (condition == 'diabetes' || condition == 'both') {
        final data = await rootBundle.loadString(
          'assets/content/recommendations_diabetes.json',
        );
        final list = json.decode(data) as List;
        result.addAll(list.map((e) => RecommendationModel.fromMap(e)));
      }

      if (condition == 'hypertension' || condition == 'both') {
        final data = await rootBundle.loadString(
          'assets/content/recommendations_hypertension.json',
        );
        final list = json.decode(data) as List;
        result.addAll(list.map((e) => RecommendationModel.fromMap(e)));
      }

      if (condition == 'insulin_resistance') {
        final data = await rootBundle.loadString(
          'assets/content/recommendations_insulin_resistance.json',
        );
        final list = json.decode(data) as List;
        result.addAll(list.map((e) => RecommendationModel.fromMap(e)));
      }

      _recommendations = result;
    } catch (e) {
      _recommendations = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/education_model.dart';

class EducationProvider extends ChangeNotifier {
  List<EducationModel> _articles = [];
  bool _isLoading = false;

  List<EducationModel> get articles => _articles;
  bool get isLoading => _isLoading;

  Future<void> loadForCondition(String condition) async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<EducationModel> result = [];

      if (condition == 'diabetes' || condition == 'both') {
        final data = await rootBundle.loadString(
          'assets/content/education_diabetes.json',
        );
        final list = json.decode(data) as List;
        result.addAll(list.map((e) => EducationModel.fromMap(e)));
      }

      if (condition == 'hypertension' || condition == 'both') {
        final data = await rootBundle.loadString(
          'assets/content/education_hypertension.json',
        );
        final list = json.decode(data) as List;
        result.addAll(list.map((e) => EducationModel.fromMap(e)));
      }

      _articles = result;
    } catch (e) {
      _articles = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}

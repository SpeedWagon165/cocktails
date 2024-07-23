import 'dart:developer';

import 'package:dio/dio.dart';

import '../models/cocktail_list_model.dart';

class CocktailRepository {
  final Dio _dio = Dio();

  Future<List<Cocktail>> fetchCocktails() async {
    try {
      final response = await _dio.get('http://109.71.246.251:8000/api/recipe/');
      log('Response data: ${response.data}');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        // Проверяем, есть ли ключ "results"
        if (data.containsKey('results')) {
          List<dynamic> recipesJson = data['results'];
          print(recipesJson);
          return recipesJson.map((json) => Cocktail.fromJson(json)).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load cocktails: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching cocktails: ${e.toString()}');
      throw Exception('Failed to load cocktails: ${e.toString()}');
    }
  }
}

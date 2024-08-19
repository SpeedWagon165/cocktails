import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../models/cocktail_list_model.dart';

class CocktailRepository {
  Future<List<Cocktail>> fetchCocktails() async {
    try {
      final response = await http.get(
        Uri.parse('http://109.71.246.251:8000/api/recipe/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        List<Cocktail> cocktails = List<Cocktail>.from(
            jsonDecode(utf8.decode(response.bodyBytes))["results"]
                .map((x) => Cocktail.fromJson(x)));
        return cocktails;
      } else {
        throw Exception('Failed to load cocktails: ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      log('Error fetching cocktails', error: e, stackTrace: stacktrace);
      rethrow;
    }
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../models/cocktail_list_model.dart';

class CocktailRepository {
  final String baseUrl = 'http://109.71.246.251:8000/api';
  final Dio dio = Dio();

  Future<List<Cocktail>> fetchCocktails() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/recipe/'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        log('Response body: ${response.body}'); // Логируем полный ответ

        final Map<String, dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        if (jsonResponse.containsKey('results')) {
          List<Cocktail> cocktails = List<Cocktail>.from(
            jsonResponse["results"].map((x) => Cocktail.fromJson(x)),
          );
          return cocktails;
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Failed to load cocktails: ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      log('Error fetching cocktails', error: e, stackTrace: stacktrace);
      throw Exception('Failed to fetch cocktails: $e');
    }
  }

  Future<List<Cocktail>> fetchUserCocktails(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile/recipe/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      ).timeout(const Duration(seconds: 30));

      print('Response body: ${response.body}');
      print('Response body: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is! List) {
          throw Exception('Ошибка: ожидался массив JSON');
        }

        return jsonResponse.map((item) => Cocktail.fromJson(item)).toList();
      } else {
        throw Exception(
            'Ошибка загрузки коктейлей пользователя: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка при загрузке коктейлей пользователя: $e');
    }
  }
}

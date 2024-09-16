import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cocktail_list_model.dart';

class CocktailRepository {
  final String baseUrl = 'http://109.71.246.251:8000/api';
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://109.71.246.251:8000/api',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // Метод для получения коктейлей
  Future<List<Cocktail>> fetchCocktails() async {
    try {
      final response = await dio.get('/recipe/');

      if (response.statusCode == 200) {
        log('Response body: ${response.data}'); // Логируем полный ответ

        final Map<String, dynamic> jsonResponse = response.data;
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

  // Метод для получения коктейлей пользователя с токеном
  Future<List<Cocktail>> fetchUserCocktails(String token) async {
    try {
      final response = await dio.get(
        '/profile/recipe/',
        options: Options(
          headers: {
            'Authorization': 'Token $token',
          },
        ),
      );

      log('Response body: ${response.data}');
      log('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        if (jsonResponse is! List) {
          throw Exception('Ошибка: ожидался массив JSON');
        }

        return jsonResponse
            .map<Cocktail>((item) => Cocktail.fromJson(item))
            .toList();
      } else {
        throw Exception('Ошибка загрузки данных: ${response.statusCode}');
      }
    } catch (e) {
      log('Ошибка: $e');
      throw Exception('Ошибка при загрузке данных: $e');
    }
  }

  Future<List<Cocktail>> searchCocktails({
    required String query,
    String? ingredients,
    String? tools,
    String? ordering,
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await dio.get(
        '/recipe/',
        queryParameters: {
          'q': query,
          if (ingredients != null) 'ingredients': ingredients,
          if (tools != null) 'tools': tools,
          if (ordering != null) 'ordering': ordering,
          if (page != null) 'page': page,
          if (pageSize != null) 'page_size': pageSize,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        if (jsonResponse.containsKey('results')) {
          return List<Cocktail>.from(
            jsonResponse["results"].map((x) => Cocktail.fromJson(x)),
          );
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Failed to search cocktails: ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      log('Error searching cocktails', error: e, stackTrace: stacktrace);
      throw Exception('Failed to search cocktails: $e');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Метод для добавления/удаления рецепта в избранное
  Future<void> toggleFavorite(int recipeId, bool isFavorite) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final String url = isFavorite
        ? '/profile/favorite/d/' // Удаление из избранного
        : '/profile/favorite/'; // Добавление в избранное

    try {
      final response = await dio.post(
        url,
        data: {'recipe': recipeId},
        options: Options(
          headers: {
            'Authorization': 'Token $token',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to update favorite status');
      }
    } catch (e, stacktrace) {
      log('Error toggling favorite status', error: e, stackTrace: stacktrace);
      throw Exception('Failed to update favorite status: $e');
    }
  }

  Future<List<Cocktail>> fetchFavoriteCocktails() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    try {
      final response = await dio.get(
        '/profile/favorite/',
        options: Options(
          headers: {
            'Authorization': 'Token $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;

        if (jsonResponse is List) {
          return jsonResponse
              .map<Cocktail>((item) => Cocktail.fromJson(item))
              .toList();
        } else {
          throw Exception('Unexpected response format: expected a list');
        }
      } else {
        throw Exception(
            'Failed to load favorite cocktails: ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      log('Error fetching favorite cocktails',
          error: e, stackTrace: stacktrace);
      throw Exception('Failed to fetch favorite cocktails: $e');
    }
  }
}

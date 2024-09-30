import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cocktail_list_model.dart';
import '../models/ingredient_category_model.dart';

class CocktailRepository {
  final String baseUrl = 'http://109.71.246.251:8000/api';
  final Dio dio;

  CocktailRepository()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'http://109.71.246.251:8000/api',
            headers: {
              'Content-Type': 'application/json',
              'User-Language': 'rus'
            },
          ),
        ) {
    // Добавляем интерсептор для автоматического добавления токена
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Token $token';
        }
        return handler.next(options); // Продолжаем с обновленными опциями
      },
      onResponse: (response, handler) {
        // Обработка ответа
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        // Обработка ошибок
        return handler.next(e);
      },
    ));
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Метод для получения коктейлей
  Future<List<Cocktail>> fetchCocktails() async {
    try {
      // Получаем токен из SharedPreferences
      final token = await _getToken();

      // Настраиваем опции запроса
      Options options;
      if (token != null) {
        // Если токен есть, добавляем его в заголовки
        options = Options(
          headers: {
            'Authorization': 'Token $token',
          },
        );
      } else {
        // Если токена нет, заголовки не нужны
        options = Options();
      }

      // Выполняем запрос
      final response = await dio.get(
        '/recipe/',
        options: options,
      );

      // Обрабатываем ответ
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
    String? query,
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
          if (query != null) 'q': query,
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

  Future<List<Cocktail>> searchFavoriteCocktails({
    String? query,
    String? ingredients,
    String? tools,
    String? ordering,
    int? page,
    int? pageSize,
  }) async {
    try {
      // Получаем токен, если есть
      final token = await _getToken();

      // Настраиваем опции запроса
      Options options = Options();
      if (token != null) {
        options = Options(
          headers: {
            'Authorization': 'Token $token',
          },
        );
      }

      final response = await dio.get(
        '/recipe/', // Ваш endpoint для поиска коктейлей
        options: options,
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
        final List<dynamic> jsonResponse = response.data['results'];
        if (jsonResponse.isNotEmpty) {
          // Фильтруем коктейли по полю is_favorite
          List<Cocktail> favoriteCocktails = jsonResponse
              .map((item) => Cocktail.fromJson(item))
              .where((cocktail) => cocktail.isFavorite == true)
              .toList();

          return favoriteCocktails;
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Failed to search cocktails: ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      log('Error searching favorite cocktails',
          error: e, stackTrace: stacktrace);
      throw Exception('Failed to search favorite cocktails: $e');
    }
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
            'Не удалось загрузить избранные рецепты: ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      log('Ошибка при получении избранных коктейлей',
          error: e, stackTrace: stacktrace);
      throw Exception('Ошибка при загрузке избранных коктейлей: $e');
    }
  }

  Future<List<Section>> fetchSections() async {
    try {
      final response = await dio.get('/recipe/section/');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Section.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка при загрузке секций: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка при загрузке данных: $e');
    }
  }

  Future<List<Tool>> fetchTools() async {
    try {
      final response = await dio.get('/recipe/tool/');
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Tool.fromJson(json)).toList();
      } else {
        throw Exception(
            'Ошибка при загрузке инструментов: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка при загрузке данных: $e');
    }
  }

  Future<void> createRecipe(Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);
      print("Request data: $data");

      final response = await dio.post(
        'http://109.71.246.251:8000/api/recipe/',
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Recipe created successfully!");
      } else {
        throw Exception('Failed to create recipe: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating recipe: $e');
      throw e;
    }
  }
}

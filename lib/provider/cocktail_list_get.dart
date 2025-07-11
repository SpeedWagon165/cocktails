import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cocktail_list_model.dart';
import '../models/ingredient_category_model.dart';
import '../utilities/language_swich.dart';

class CocktailRepository {
  final Dio dio;

  CocktailRepository()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'http://37.252.17.123:8000/api/',
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        ) {
    // Добавляем интерсептор для автоматического добавления токена
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _getToken();
        final userLanguage =
            await LanguageService.getLanguage(); // Получаем сохранённый язык

        options.headers['User-Language'] =
            userLanguage; // Устанавливаем язык в заголовке
        if (token != null) {
          options.headers['Authorization'] = 'Token $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Обработка ответа
        return handler.next(response);
      },
      onError: (e, handler) {
        // Обработка ошибок
        return handler.next(e);
      },
    ));
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Cocktail> fetchCocktailById(String cocktailId) async {
    try {
      final response = await dio.get('/recipe/$cocktailId');
      if (response.statusCode == 200) {
        return Cocktail.fromJson(response.data);
      } else {
        throw Exception('Failed to load cocktail: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching cocktail by ID', error: e);
      throw Exception('Failed to fetch cocktail: $e');
    }
  }

  // Метод для получения коктейлей
  Future<List<Cocktail>> fetchCocktails({
    int page = 1,
    int pageSize = 20,
    bool? alc,
  }) async {
    try {
      final response = await dio.get(
        '/recipe/',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          'ordering': 'title',
          if (alc != null) 'alc': alc ? 'True' : 'False',
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
        throw Exception('Failed to load cocktails: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching cocktails', error: e);
      throw Exception('Failed to fetch cocktails: $e');
    }
  }

  // Метод для получения коктейлей пользователя с токеном
  Future<List<Cocktail>> fetchUserCocktails(
      {String? query, int page = 1, int pageSize = 50}) async {
    try {
      final response = await dio.get(
        '/profile/recipe/',
        options: Options(),
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          if (query != null && query.isNotEmpty) 'q': query,
        },
      );

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

  Future<CocktailResponseModel> searchCocktails({
    String? query,
    String? ingredients,
    String? tools,
    String? ordering,
    int? page,
    int? pageSize,
    bool? alc,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        if (query != null) 'q': query,
        if (ingredients != null) 'ingredients': ingredients,
        if (tools != null) 'tools': tools,
        if (ordering != null) 'ordering': ordering,
        if (page != null) 'page': page,
        if (pageSize != null) 'page_size': pageSize,
        if (alc != null) 'alc': alc ? 'True' : 'False',
      };
      final response =
          await dio.get('/recipe/', queryParameters: queryParameters);
      print("$queryParameters, это в репе");
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        print(jsonResponse["count"]);
        if (jsonResponse.containsKey('results')) {
          return CocktailResponseModel(
              cocktails: List<Cocktail>.from(
                jsonResponse["results"].map((x) => Cocktail.fromJson(x)),
              ),
              count: jsonResponse["count"]);
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Failed to search cocktails: ${response.statusCode}');
      }
    } catch (e) {
      log('Error searching cocktails', error: e);
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
      Response response;
      if (isFavorite) {
        response = await dio.post(
          url,
          data: {'recipe': recipeId},
          options: Options(headers: {'Authorization': 'Token $token'}),
        );
      } else {
        response = await dio.post(
          url,
          data: {'recipe': recipeId},
          options: Options(headers: {'Authorization': 'Token $token'}),
        );
      }

      if (response.statusCode != 200 &&
          response.statusCode != 204 &&
          response.statusCode != 201) {
        throw Exception(
            'Failed to update favorite status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 &&
          e.response?.data['detail'] == "Recipe is not in favorites") {
        log("Recipe is not in favorites, marking icon as inactive.");
        return; // Просто выходим без ошибки
      }
      log('Error toggling favorite status', error: e);
      throw Exception('Failed to update favorite status: $e');
    } catch (e, stacktrace) {
      log('Unexpected error', error: e, stackTrace: stacktrace);
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
      print(response.statusCode);
      print(response.data);
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
      final response = await dio.get(
        '/recipe/tool/',
        queryParameters: {
          'ordering': 'name',
        },
      );
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
      print('▶ formData.fields:');
      formData.fields.forEach((field) {
        print('  ${field.key}: ${field.value}');
      });

// 2) Выведем все файлы и их размеры
      print('▶ formData.files:');
      for (var entry in formData.files) {
        final key = entry.key;
        final mp = entry.value as MultipartFile;
        final filename = mp.filename;
        final length = mp.length; // вот здесь берем размер
        print('  $key — $filename — $length bytes');
      }
      print("Request data: $data");
      print(formData);

      final response = await dio.post(
        '/recipe/',
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

  Future<void> publishCocktail(int cocktailId) async {
    try {
      final response = await dio.get('/profile/recipe/$cocktailId/pending/');
      print(response.statusCode.toString());
      if (response.statusCode != 200) {
        print("коктейль опубликован");
        throw Exception('Failed to publish cocktail');
      }
    } catch (e) {
      log('Error publishing cocktail: $e');
      throw Exception('Failed to publish cocktail: $e');
    }
  }

  Future<void> claimRecipe(int recipeId) async {
    try {
      await dio
          .post('/recipe/claim/', data: {'recipe_id': recipeId.toString()});
    } catch (e) {
      throw Exception('Не удалось отметить рецепт как приготовленный: $e');
    }
  }

  Future<String> getVideoUploadUrl(String s3Key) async {
    final resp = await dio.get(
      '/admin/recipe/video-upload-url/',
      queryParameters: {'s3_key': s3Key},
    );
    // Предполагаем, что бэк вернёт JSON: { "upload_url": "https://..." }
    return resp.data['upload_url'] as String;
  }

  /// 2) Загрузка байтов видео на presigned URL
  Future<void> uploadVideoToS3(String uploadUrl, List<int> bytes) async {
    // Отдельный Dio без ваших базовых опций (нужен публичный S3 URL)
    final s3client = Dio();
    await s3client.put(
      uploadUrl,
      data: Stream.fromIterable([bytes]),
      options: Options(
        headers: {'Content-Type': 'video/mp4'},
      ),
    );
  }
}

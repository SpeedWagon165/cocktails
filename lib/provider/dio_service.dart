import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioService {
  final String baseUrl = 'http://109.71.246.251:8000/api';
  late Dio dio;

  DioService() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'User-Language': 'rus',
        },
      ),
    );

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
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  final String baseUrl = 'http://109.71.246.251:8000/api';
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://109.71.246.251:8000/api',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // Функция для получения токена из SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Функция для сохранения профиля в SharedPreferences
  Future<void> _saveProfileToCache(Map<String, dynamic> profileData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('profile', jsonEncode(profileData));
  }

  // Функция для загрузки профиля из SharedPreferences
  Future<Map<String, dynamic>?> _getProfileFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final String? profileString = prefs.getString('profile');
    if (profileString != null) {
      return jsonDecode(profileString) as Map<String, dynamic>;
    }
    return null;
  }

  // Функция для загрузки профиля с сервера
  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      // Сначала проверяем наличие профиля в кэше
      final cachedProfile = await _getProfileFromCache();
      if (cachedProfile != null) {
        return cachedProfile;
      }

      // Если профиля в кэше нет, загружаем его с сервера
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await dio.get(
        '/profile/',
        options: Options(
          headers: {
            'Authorization': 'Token $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final profileData = response.data as Map<String, dynamic>;

        // Сохраняем загруженные данные в кэш
        await _saveProfileToCache(profileData);

        return profileData;
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }
}

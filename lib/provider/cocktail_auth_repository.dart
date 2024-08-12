import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cocktail_auth_response_model.dart';

class AuthRepository {
  final Dio _dio = Dio();

  Future<AuthResponse> signIn(String username, String password) async {
    try {
      final response = await _dio.post(
        'http://109.71.246.251:8000/api/auth/web/sign-in/',
        data: ({'username': username, 'password': password}),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
            'X-CSRFToken':
                'W5nOpCdcuuCYNNYSjmt10MLTNZ3yHrYKtiWAV67rNEKddGlUbsx9RXOfWegmqVvb',
          },
        ),
      );
      print('Request sent: ${({'username': username, 'password': password})}');
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', authResponse.token);
        print('Sign-in successful, token: ${authResponse.token}');
        return authResponse;
      } else {
        print('Failed to sign in: ${response.statusCode}');
        throw Exception('Failed to sign in: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during sign-in: $e');
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> verifyEmail(String email) async {
    try {
      final response = await _dio.post(
        'http://109.71.246.251:8000/api/auth/auth/verify-email/',
        data: {'email': email},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
            'X-CSRFToken':
                'EM7evcIdIKNImaIaITStWkxMiJcvfNopWcmppbnGkpEHUjYXZhybikeBpQTIA2yu',
          },
        ),
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Verification code sent successfully');
      } else {
        print('Failed to send verification email: ${response.statusCode}');
        throw Exception('Failed to send verification email');
      }
    } catch (e) {
      print('Error sending verification email: $e');
      throw Exception('Failed to send verification email: $e');
    }
  }

  Future<void> confirmCode(String email, String code) async {
    try {
      final response = await _dio.post(
        'http://109.71.246.251:8000/api/auth/auth/confirm-code/',
        data: {'email': email, 'code': code},
      );
      if (response.statusCode == 200) {
        print('Verification code sent successfully');
      } else {
        print('Failed to send verification email: ${response.statusCode}');
        throw Exception('Failed to send verification email');
      }
    } catch (e) {
      throw Exception('Failed to confirm code: $e');
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String phone,
    required String gender,
    required String dateOfBirth,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        'http://109.71.246.251:8000/api/auth/auth/register/',
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'gender': gender,
          'date_of_birth': dateOfBirth,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        print('Verification code sent successfully');
      } else {
        print('Failed to send verification email: ${response.statusCode}');
        throw Exception('Failed to send verification email');
      }
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }
}

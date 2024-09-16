import 'package:dio/dio.dart';

class GoodsRepository {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://109.71.246.251:8000/api',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<List<dynamic>> fetchGoods() async {
    try {
      final response = await dio.get('/goods/');
      if (response.statusCode == 200) {
        return response.data['results'];
      } else {
        throw Exception('Failed to load goods');
      }
    } catch (e) {
      throw Exception('Error fetching goods: $e');
    }
  }
}

import 'package:dio/dio.dart';

import '../models/store_model.dart';

class GoodsRepository {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://109.71.246.251:8000/api',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<List<Product>> fetchGoods() async {
    try {
      final response = await dio.get('/goods/');
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load goods');
      }
    } catch (e) {
      throw Exception('Error fetching goods: $e');
    }
  }
}

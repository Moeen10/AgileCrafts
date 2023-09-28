import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task/models/product_model.dart';
import 'package:task/utils/common.dart';

class PostRepository {
  Future<List<Product>> fetchPosts() async {
    try {
      final String apiUrl =
          'https://stg-zero.propertyproplus.com.au/api/services/app/ProductSync/GetAllproduct';
      final String accessToken = AccessToken.tokenValue;
      print("--------------------");

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        List<dynamic> postsData =
            responseBody; // Assuming the response is a List
        return postsData.map((postData) => Product.fromJson(postData)).toList();
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
        throw Exception(
            'Failed to fetch data'); // Add an exception to indicate the failure
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
}

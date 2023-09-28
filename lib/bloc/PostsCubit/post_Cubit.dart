import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task/bloc/PostsCubit/state_cubit.dart';
import 'package:task/models/product_model.dart';
import 'package:task/repository/getRepository/post_repository.dart';
import 'package:task/utils/common.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
class PostCubit extends Cubit<PostState> {
  PostCubit() : super(LoadingState()) {
    fetchPosts();
  }

  PostRepository postRepository = PostRepository();

  void fetchPosts() async {
    try {
      print("*************");
      emit(LoadingState());
      List<Product> posts = await fetchProduct();
      emit(GetDataState(posts));

    } catch (e) {
      emit(ErrorMesageState(e.toString()));
      print("---------  ERROR From post_Cubit--------fetchPosts() functions");
      throw e;
    }
  }



  Future<List<Product>> fetchProduct() async {
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

      print("LOad data Status Code: ");
      print(response.statusCode);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        List<dynamic> postsData = responseBody; // Assuming the response is a List
        final box = await Hive.openBox<Product>("products");
        await box.clear();

        for (var data in responseBody) {
          box.add(Product(
            tenantId: data['tenantId'],
            name: data['name'],
            description: data['description'],
            isAvailable: data['isAvailable'],
            id: data['id'],
          ));
        }
        return postsData.map((postData) => Product.fromJson(postData)).toList();
      } else {
        emit(NotGetDataState());
        // Request failed
        print('Request failed with status: ${response.statusCode}');
        throw Exception(
            'Failed to fetch data'); // Add an exception to indicate the failure
      }
    } catch (e) {

      emit(NotGetDataState());
      print('Error: $e');
      throw e;
    }
  }
}

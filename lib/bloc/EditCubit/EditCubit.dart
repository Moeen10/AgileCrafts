import 'dart:convert';

import 'package:task/bloc/EditCubit/EditState.dart';
import 'package:task/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/utils/common.dart';
import 'package:http/http.dart' as http;

class EditCubit extends Cubit<EditState> {
  MyFormData project = MyFormData();
  Product singleProduct = Product();
  EditCubit() : super(NoEditState());

  void editPermission(bool ok, Product singleProduct) {
    if (ok) {
      emit(DoEditState(singleProduct));
    } else {
      emit(NoEditState());
    }
  }

  void edit (project,int id) async {
    print("Id number is $id");
    final url = Uri.parse(
        'https://stg-zero.propertyproplus.com.au/api/services/app/ProductSync/CreateOrEdit');

    final headers = {
      "Authorization": 'Bearer ${AccessToken.tokenValue}',
      "Content-Type": "application/json",
    };

    final body = {
      "name": "${project.name}",
      "description": "${project.description}",
      "isAvailable": project.isAvailable,
      "id": id,
    };

    final response =
    await http.post(url, headers: headers, body: jsonEncode(body));

    print(response.statusCode);
    if (response.statusCode == 200) {
      emit(DoneEditState());
      print("Product added successfully");
      // Handle success
    } else {
      emit(ErrorEditState("Failed to add product"));
      print("Failed to add product");
      // Handle error
    }
  }
}

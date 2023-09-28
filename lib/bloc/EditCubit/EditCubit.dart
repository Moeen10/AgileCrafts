import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:task/bloc/EditCubit/EditState.dart';
import 'package:task/models/product_model.dart';
import 'package:task/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/utils/common.dart';
import 'package:http/http.dart' as http;
import 'package:task/screens/homePage.dart';

class EditCubit extends Cubit<EditState> {
  MyFormData project = MyFormData();
  Product singleProduct = Product();
  EditCubit() : super(NoEditState());
  final box = Hive.box<Product>("products");
  void editPermission(bool ok, Product singleProduct) {
    if (ok) {
      emit(DoEditState(singleProduct));
    } else {
      emit(NoEditState());
    }
  }

  void OfflineEditPermission(bool ok, Product singleProduct) {
    if (ok) {
      emit(OfflineDoEditState(singleProduct));
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

  void OfflineEdit(MyFormData EditData,int idd) async {
    final int productId = idd ?? 0; // Replace 0 with a default value if needed

    // Fetch the existing product from the Hive box
    final Product existingProduct = box.get(productId) as Product;

    if (existingProduct != null) {
      // Update the existing product with the edited values
      existingProduct.name = EditData.name;
      existingProduct.description = EditData.description;
      existingProduct.isAvailable = EditData.isAvailable;

      // Replace the old product with the updated product in the Hive box
      box.put(productId, existingProduct);
      // final products = box.values.toList().cast<Product>();
      // await box.clear(); // Clear the previous data
      // await box.addAll(products);
      //hiveDataChangedNotifier.value = true;
print("HHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
      emit(DoneOfflineEditState());

    } else {
      // Handle the case where the product with the specified ID is not found
      print("Product with ID $productId not found in Hive");
    }
  }

}




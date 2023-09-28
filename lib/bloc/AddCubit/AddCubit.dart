import 'dart:convert';

import 'package:task/bloc/AddCubit/AddState.dart';
import 'package:task/bloc/LoginCubit/LoginState.dart';
import 'package:task/utils/common.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class AddCubit extends Cubit<AddState> {
  MyFormData project = MyFormData();

  AddCubit() : super(AddInitialStateState());

  void addProject(bool openOrClose) {
    if (openOrClose) {
      emit(OpenAddState());
    }
    if (!openOrClose) {
      emit(CancelAddState());
    } else {}
  }

  void productAdd(project) async {
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
    };

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    print(response.statusCode);
    if (response.statusCode == 200) {
      emit(DoneAddState());
      print("Product added successfully");
      // Handle success
    } else {
      emit(ErrorAddState("Failed to add product"));
      print("Failed to add product");
      // Handle error
    }
  }

  // void productAdd ( project ) async{
  //   print("Moeen");
  //  print(project.isAvailable);
  //   final url = Uri.parse('https://stg-zero.propertyproplus.com.au/api/TokenAuth/Authenticate'); // Replace with your API endpoint
  //   final headers = {
  //     "Authorization": 'Bearer ${AccessToken.tokenValue}',
  //     "Content-Type": "application/json",
  //   };
  //   final body = {
  //     "name": "${project.name}",
  //     "description": "${project.description}",
  //     "isAvailable": project.isAvailable,
  //   };
  //   final response = await http.post(url, headers: headers, body: jsonEncode(body));
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     emit(DoneAddState());
  //   } else {
  //     emit(ErrorAddState("Can not add successfully"));
  //   }
  // }
}







//
// class ProjectAdd {
//   FutureOr<String> AddProjectFun() async {
//     print("!!!!!!!!!!");
//     print(username);
//     print(password);
//
//     final url = Uri.parse('https://stg-zero.propertyproplus.com.au/api/TokenAuth/Authenticate'); // Replace with your API endpoint
//     final headers = {
//       'Content-Type': 'application/json', // Set the content type as JSON
//       'Abp.TenantId': "10",
//     };
//
//     final body = {
//       'userNameOrEmailAddress': "asif",
//       'password': "password1",
//     };
//
//     final response = await http.post(url, headers: headers, body: jsonEncode(body));
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       final result = jsonDecode(response.body);
//       AccessToken.tokenValue = result['result']['accessToken'].toString();
//       return result['result']['accessToken'];
//     } else {
//       return 'Authentication failed';
//     }
//   }
// }
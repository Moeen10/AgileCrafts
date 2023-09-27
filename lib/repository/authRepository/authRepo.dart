import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task/models/authenticationModel.dart';
class AuthRepository {
  FutureOr<String> login(String username, String password) async {
    print("!!!!!!!!!!");
    print(username);
    print(password);

    final url = Uri.parse('https://stg-zero.propertyproplus.com.au/api/TokenAuth/Authenticate'); // Replace with your API endpoint
    final headers = {
      'Content-Type': 'application/json', // Set the content type as JSON
      'Abp.TenantId': "10",
    };

    final body = {
      'userNameOrEmailAddress': "asif",
      'password': "password1",
    };

    final response = await http.post(url, headers: headers, body: jsonEncode(body));
print(response.statusCode);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['result']['accessToken'];
    } else {
      return 'Authentication failed';
    }
  }
}
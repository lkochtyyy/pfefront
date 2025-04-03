import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRepository {
  final String baseUrl = "http://10.0.2.2:3000"; 

  Future<Map<String, dynamic>> register(UserModel user) async {
  final response = await http.post(
    Uri.parse("$baseUrl/user/register"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(user.toJson()),
  );

  final responseData = jsonDecode(response.body);
  if (response.statusCode == 201) {
    return {
      "message": responseData["message"],
      "userId": responseData["userId"].toString(),  
    };
  } else {
    throw Exception(responseData["message"] ?? "Registration failed");
  }
}

Future<Map<String, dynamic>> login(String email, String password) async {
  final response = await http.post(
    Uri.parse("$baseUrl/user/signIn"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"email": email, "password": password}),
  );

  final responseData = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return {
      "token": responseData["token"],  
      "userId": responseData["userId"].toString(),  
    };
  } else {
    throw Exception(responseData["message"] ?? "Login failed");
  }
}

}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';  // Importer SharedPreferences
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
      // Sauvegarder l'ID de l'utilisateur et le token dans SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = responseData["userId"].toString();
      final token = responseData["token"];

      // Enregistrer l'ID et le token dans SharedPreferences
      await prefs.setString('userId', userId);
      await prefs.setString('token', token);

      return {
        "token": token,
        "userId": userId,
      };
    } else {
      throw Exception(responseData["message"] ?? "Login failed");
    }
  }
 Future<UserModel> getUserById(String userId) async {
  
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    throw Exception('Token introuvable dans SharedPreferences');
  }

  final response = await http.get(
    Uri.parse('$baseUrl/user/$userId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    
    final responseData = jsonDecode(response.body);
    print("==> responseData: $responseData");

    final user = UserModel.fromJson(responseData);
    
    return user;
  } else {
    final errorData = jsonDecode(response.body);
    throw Exception(errorData['message'] ?? 'Erreur lors de la récupération');
  }
}
Future<Map<String, dynamic>> deleteUser(String userId) async {
  try {
    print("debut ..... deletion");
    final response = await http.delete(Uri.parse('$baseUrl/user/$userId'));
    final responseData = jsonDecode(response.body);
    return responseData; // Retourner la réponse du backend
   
  } catch (e) {
    throw Exception('Erreur lors de la suppression de l\'utilisateur : ${e.toString()}');
  }
}




  requestPasswordReset(String email) {}

  verifyResetCode(String code) {}

  updatePassword(String newPassword) {}
}

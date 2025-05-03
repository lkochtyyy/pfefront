import 'dart:convert';
import 'package:http/http.dart' as http;


class ForgetpassRepository {
  final String baseUrl = "http://192.168.0.8:3000"; 
  
  
    Future<Map<String, dynamic>> requestPasswordReset(String email) async {
      final response = await http.post(
        Uri.parse("$baseUrl/user/forgot-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );
  
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          "message": responseData["message"],
          "verificationCode": responseData["verificationCode"],
          
        };
        
      } else {
        throw Exception(responseData["message"] ?? "Request failed");
      }
    }
  Future<Map<String, dynamic>> resetpassword(String email ,int receivedcode ,String verificationCode, String newPassword) async {
      final response = await http.post(
        Uri.parse("$baseUrl/user/reset-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "receivedcode": receivedcode, "verificationCode": verificationCode, "newPassword": newPassword}),
      );
  
      final responseData = jsonDecode(response.body);
      print(responseData);
      if (response.statusCode == 200) {
        return {
          "message": responseData["message"],
        };
      } else {
        throw Exception(responseData["message"] ?? "Request failed");
      }
    }  

}
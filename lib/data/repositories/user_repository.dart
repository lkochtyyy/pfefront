import 'package:http/http.dart' as http;
import 'dart:convert';

class UserRepository {
  final String baseUrl = "http://192.168.0.8:3000"; 

  

 Future<String> updateNom(int userId, String nom) async {
  final url = Uri.parse('$baseUrl/user/$userId/nom'); // adapte cette URL à ton backend
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'newNom': nom});

  print("🔵 Requête PUT vers: $url");
  print("🔵 Headers: $headers");
  print("🔵 Body: $body");

  final response = await http.put(url, headers: headers, body: body);

  print("🟡 StatusCode: ${response.statusCode}");
  print("🟡 Body response: ${response.body}");

  if (response.statusCode == 200) {
    return "Nom mis à jour avec succès";
  } else {
    throw Exception('Erreur lors de la mise à jour du prénom');
  }
}


 Future<String> updatePrenom(int userId, String prenom) async {
  final response = await http.put(
    Uri.parse('$baseUrl/user/$userId/prenom'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'newPrenom': prenom}),
  );

  if (response.statusCode == 200) {
    return "Prénom mis à jour avec succès";
  } else {
    throw Exception('Erreur lors de la mise à jour du prénom');
  }
}
  Future<void> updateNumTel(int userId, String newNumTel) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user/$userId/numTel'),
      body: {'newNumTel': newNumTel},
    );
    if (response.statusCode != 200) throw Exception('Erreur update tel');
  }

  Future<void> updatePassword(int userId, String newPassword) async {
    final url = Uri.parse('$baseUrl/user/$userId/password'); // adapte cette URL à ton backend
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'newPassword': newPassword});

  print("🔵 Requête PUT vers: $url");
  print("🔵 Headers: $headers");
  print("🔵 Body: $body");

  final response = await http.put(url, headers: headers, body: body);

  print("🟡 StatusCode: ${response.statusCode}");
  print("🟡 Body response: ${response.body}");

  if (response.statusCode == 200) {
   
  } else {
    throw Exception('Erreur lors de la mise à jour du mot de passe');
  }
}
}
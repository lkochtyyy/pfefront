import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pfefront/data/models/Model%20Favori.dart';

class FavoriRepository {
  final String baseUrl = 'http://192.168.0.8:3000/favoris';

  Future<void> ajouterFavori(int userId, int carId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'car_id': carId}),
    );

    if (response.statusCode != 201) {
      throw Exception('Erreur lors de l’ajout du favori');
    }
  }

  Future<List<Favori>> getFavorisByUser(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/$userId'));
    print("API Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['favoris'] as List;
      return data.map((json) => Favori.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des favoris');
    }
  }

  Future<void> deleteFavori(int userId, int carId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$userId/$carId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression du favori');
    }
  }
}

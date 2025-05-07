import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pfefront/data/models/announcement_model.dart';

class CarAnnouncementRepository {
  final Dio dio;

  CarAnnouncementRepository({required this.dio});

  // Récupérer toutes les annonces
  Future<List<CarAnnouncement>> fetchAll() async {
    try {
      final response = await dio.get('http://10.0.2.2:3000/carAnnouncement/');
      return (response.data as List)
          .map((e) => CarAnnouncement.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception("Échec du chargement des annonces: ${e.message}");
    }
  }

Future<CarAnnouncement> createAnnouncement(
  CarAnnouncement announcement,
  File imageFile,
) async {
  try {
    // Upload de l'image (this now returns just the filename)
    final imageName = await _uploadImage(imageFile);
    print("✅ Image uploadée avec succès: $imageName");

    // Create announcement with just the filename
    final response = await dio.post(
      'http://10.0.2.2:3000/carAnnouncement/', 
      data: announcement.copyWith(imageUrl: imageName).toJson(),
    );

    print("✅ Annonce créée avec succès !");
    print("📝 Données reçues : ${response.data}");

    return announcement.copyWith(imageUrl: imageName);
  } on DioException catch (e) {
    print("❌ Erreur lors de la création d'annonce: ${e.message}");
    throw Exception("Échec de la création: ${e.message}");
  }
}


 Future<String> _uploadImage(File file) async {
  try {
    print('🚀 Début de l\'upload: ${file.path}');
    
    final dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:3000'));

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
    });

    final response = await dio.post('/uploadCarImage', data: formData);

    print('✅ Réponse upload: ${response.data}');
    
    // Return just the filename instead of the full URL
    return response.data['fileName'];
  } catch (e) {
    print('❌ Erreur d\'upload: $e');
    rethrow;
  }
}





  // Supprimer une annonce
  Future<void> deleteAnnouncement(int id) async {
    try {
      await dio.delete('http://10.0.2.2:3000/carAnnouncement/$id');
       print('✅ Annonce supprimée avec succès');
    } on DioException catch (e) {
       print('❌ Erreur lors de la suppression : ${e.message}');
      throw Exception("Échec de la suppression: ${e.message}");
    }
  }

  // ⚠️ Avant c'était vide ! On le lie à createAnnouncement maintenant.
  Future<void> create(CarAnnouncement announcement, File imageFile) async {
    await createAnnouncement(announcement, imageFile);
  }

Future<CarAnnouncement> fetchById(int id) async {
  try {
     print("🚀 Début ...");
    final response = await dio.get('http://10.0.2.2:3000/carAnnouncement/$id');
    return CarAnnouncement.fromJson(response.data);
    
  } on DioException catch (e) {
    throw Exception("Erreur lors du chargement de l'annonce: ${e.message}");
  }
}
Future<List<CarAnnouncement>> fetchByVendor(int vendorId) async {
  try {
    final response = await dio.get('http://10.0.2.2:3000/carAnnouncement/vendor/$vendorId');

    if (response.statusCode == 200) {
      final data = response.data;

      // Vérifiez si la réponse est une liste
      if (data is List) {
        return data.map((json) => CarAnnouncement.fromJson(json)).toList();
      } else {
        throw Exception("La réponse du serveur n'est pas une liste.");
      }
    } else {
      throw Exception('Erreur lors de la récupération des annonces.');
    }
  } on DioException catch (e) {
    throw Exception("Erreur lors de la récupération des annonces : ${e.message}");
  }
}
Future<void> updateAnnouncement(Map<String, dynamic> updatedData) async {
  try {
    await dio.put(
      'http://10.0.2.2:3000/carAnnouncement/${updatedData['id']}',
      data: updatedData,
    );
    print('✅ Annonce mise à jour avec succès');
  } on DioException catch (e) {
    print('❌ Erreur lors de la mise à jour : ${e.message}');
    throw Exception("Échec de la mise à jour : ${e.message}");
  }
}

}
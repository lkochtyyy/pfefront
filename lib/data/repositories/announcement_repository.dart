import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pfefront/data/models/announcement_model.dart';

class CarAnnouncementRepository {
  final Dio dio;

  CarAnnouncementRepository({required this.dio});

  // Récupérer toutes les annonces
  Future<List<CarAnnouncement>> fetchAll() async {
    try {
      final response = await dio.get('/announcements');
      return (response.data as List)
          .map((e) => CarAnnouncement.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception("Échec du chargement des annonces: ${e.message}");
    }
  }

  // Créer une annonce avec image
  Future<CarAnnouncement> createAnnouncement(
    CarAnnouncement announcement, 
    File imageFile,
  ) async {
    try {
      final imageUrl = await _uploadImage(imageFile);
      final response = await dio.post(
        '/announcements',
        data: announcement.copyWith(imageUrl: imageUrl).toJson(),
      );
      return CarAnnouncement.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception("Échec de la création: ${e.message}");
    }
  }

  // Uploader une image
  Future<String> _uploadImage(File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
      });
      final response = await dio.post('/upload', data: formData);
      return response.data['url'] as String;
    } on DioException catch (e) {
      throw Exception("Échec de l'upload: ${e.message}");
    }
  }

  // Supprimer une annonce
  Future<void> deleteAnnouncement(int id) async {
    try {
      await dio.delete('/announcements/$id');
    } on DioException catch (e) {
      throw Exception("Échec de la suppression: ${e.message}");
    }
  }

  create(CarAnnouncement announcement, File imageFile) {}
}
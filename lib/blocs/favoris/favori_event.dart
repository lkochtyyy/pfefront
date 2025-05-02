abstract class FavoriEvent {}

class AjouterFavori extends FavoriEvent {
  final int userId;
  final int carId;

  AjouterFavori({required this.userId, required this.carId});
}

class GetFavoris extends FavoriEvent {
  final int userId;

  GetFavoris(this.userId);
}

class SupprimerFavori extends FavoriEvent {
  final int userId;
  final int carId;

  SupprimerFavori({required this.userId, required this.carId});
}

import 'package:pfefront/data/models/Model%20Favori.dart';

abstract class FavoriState {}

class FavoriInitial extends FavoriState {}

class FavoriLoading extends FavoriState {}

class FavoriLoaded extends FavoriState {
  final List<Favori> favoris;

  FavoriLoaded(this.favoris);
}

class FavoriError extends FavoriState {
  final String message;

  FavoriError(this.message);
}

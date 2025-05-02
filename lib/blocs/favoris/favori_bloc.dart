import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfefront/data/repositories/FavoriRepository.dart';
import 'favori_event.dart';
import 'favori_state.dart';


class FavoriBloc extends Bloc<FavoriEvent, FavoriState> {
  final FavoriRepository favoriRepository;

  FavoriBloc(this.favoriRepository) : super(FavoriInitial()) {
    on<AjouterFavori>((event, emit) async {
      emit(FavoriLoading());
      try {
        await favoriRepository.ajouterFavori(event.userId, event.carId);
        add(GetFavoris(event.userId)); // Refresh
      } catch (e) {
        emit(FavoriError(e.toString()));
      }
    });

    on<GetFavoris>((event, emit) async {
      emit(FavoriLoading());
      try {
        final favoris = await favoriRepository.getFavorisByUser(event.userId);
        emit(FavoriLoaded(favoris));
      } catch (e) {
        emit(FavoriError(e.toString()));
      }
    });

    on<SupprimerFavori>((event, emit) async {
      emit(FavoriLoading());
      try {
        await favoriRepository.deleteFavori(event.userId, event.carId);
        add(GetFavoris(event.userId)); // Refresh
      } catch (e) {
        emit(FavoriError(e.toString()));
      }
    });
  }
}

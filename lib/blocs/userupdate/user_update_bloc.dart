import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfefront/data/repositories/user_repository.dart';
import 'user_update_event.dart';
import 'user_update_state.dart';


class UserUpdateBloc extends Bloc<UserUpdateEvent, UserUpdateState> {
  final UserRepository userRepository;

  UserUpdateBloc(this.userRepository) : super(UserUpdateInitial()) {
    on<UpdateNomEvent>((event, emit) async {
      emit(UserUpdateLoading());
      try {
        await userRepository.updateNom(event.userId, event.newNom);
        emit(UserUpdateSuccess("Nom mis à jour avec succès."));
      } catch (e) {
        print('Erreur dans UserUpdateBloc: $e');
        emit(UserUpdateFailure("Erreur lors de la mise à jour du nom."));
      }
    });

    on<UpdatePrenomEvent>((event, emit) async {
      emit(UserUpdateLoading());
      try {
        await userRepository.updatePrenom(event.userId, event.newPrenom);
        emit(UserUpdateSuccess("Prénom mis à jour avec succès."));
      } catch (e) {
        emit(UserUpdateFailure("Erreur lors de la mise à jour du prénom."));
      }
    });

    on<UpdateNumTelEvent>((event, emit) async {
      emit(UserUpdateLoading());
      try {
        await userRepository.updateNumTel(event.userId, event.newNumTel);
        emit(UserUpdateSuccess("Numéro de téléphone mis à jour avec succès."));
      } catch (e) {
        emit(UserUpdateFailure("Erreur lors de la mise à jour du numéro."));
      }
    });

    on<UpdatePasswordevent>((event, emit) async {
      emit(UserUpdateLoading());
      try {
        await userRepository.updatePassword(event.userId, event.newPassword);
        emit(UserUpdateSuccess("Mot de passe mis à jour avec succès."));
      } catch (e) {
        emit(UserUpdateFailure("Erreur lors de la mise à jour du mot de passe."));
      }
    });
  }
}

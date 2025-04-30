import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfefront/data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RegisterUser>(_onRegisterUser);
    on<LoginUser>(_onLoginUser);
    on<FetchUserProfile>(_onFetchUserProfile);
    on<DeleteUser>(_onDeleteUser);

  }

  Future<void> _onRegisterUser(RegisterUser event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  try {
    final response = await authRepository.register(event.user);
    final message = response['message'];
    final userId = response['userId']; 
    emit(AuthSuccess(message, userId)); 
  } catch (e) {
    emit(AuthFailure(e.toString()));
  }
}

Future<void> _onLoginUser(LoginUser event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  try {
    final response = await authRepository.login(event.email, event.password);
    final token = response['token']; 
    final userId = response['userId'];  
    emit(LoginSuccess(token, userId));  
  } catch (e) {
    emit(AuthFailure(e.toString()));
  }
}
 Future<void> _onFetchUserProfile(
    FetchUserProfile event, Emitter<AuthState> emit) async {
  emit(UserProfileLoading());
  try {
    final user = await authRepository.getUserById(event.userId);
    emit(UserProfileLoaded(user));
  } catch (e) {
    emit(UserProfileError(e.toString()));
  }
}

Future<void> _onDeleteUser(DeleteUser event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  try {
    final response = await authRepository.deleteUser(event.userId);
    final message = response['message']; // Message de succès du backend
    emit(UserDeleted(message));
  } catch (e) {
    emit(AuthFailure('Erreur lors de la suppression de l\'utilisateur : ${e.toString()}'));
  }
}
}
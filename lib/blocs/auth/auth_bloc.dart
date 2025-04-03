import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RegisterUser>(_onRegisterUser);
    on<LoginUser>(_onLoginUser);
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
}

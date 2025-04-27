import 'package:equatable/equatable.dart';
import 'package:pfefront/data/models/user_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  final String userId;  

  AuthSuccess(this.message, this.userId);

  @override
  List<Object?> get props => [message, userId]; 
}

class LoginSuccess extends AuthState {
  final String token;
  final String userId;  

  LoginSuccess(this.token, this.userId);

  @override
  List<Object?> get props => [token, userId];  
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}
class UserProfileLoading extends AuthState {}
class UserProfileLoaded extends AuthState {
  final UserModel user;
  UserProfileLoaded(this.user);
}
class UserProfileError extends AuthState {
  final String message;
  UserProfileError(this.message);
}
class AccountDeleted extends AuthState {
  // You can add additional properties if needed
}

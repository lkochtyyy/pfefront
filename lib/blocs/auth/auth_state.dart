import 'package:equatable/equatable.dart';

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


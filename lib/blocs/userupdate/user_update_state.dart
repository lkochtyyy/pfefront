import 'package:equatable/equatable.dart';

abstract class UserUpdateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserUpdateInitial extends UserUpdateState {}

class UserUpdateLoading extends UserUpdateState {}

class UserUpdateSuccess extends UserUpdateState {
  final String message;

  UserUpdateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UserUpdateFailure extends UserUpdateState {
  final String error;

  UserUpdateFailure(this.error);

  @override
  List<Object?> get props => [error];
}

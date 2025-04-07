import 'package:equatable/equatable.dart';

abstract class ResetPasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final String message;
  final int verificationCode;
  ResetPasswordSuccess(this.message , this.verificationCode);

  @override
  List<Object?> get props => [message ,verificationCode];
}
class ResetPassSuccess extends ResetPasswordState {
  final String message;
  ResetPassSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ResetPasswordCodeVerified extends ResetPasswordState {}

class ResetPasswordFailure extends ResetPasswordState {
  final String error;

  ResetPasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}

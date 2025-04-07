import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendResetCodeEvent extends ResetPasswordEvent {
  final String email;


  SendResetCodeEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class UpdatePasswordEvent extends ResetPasswordEvent {
  final String verificationCode;
  final String newPassword;
  final String email;
  final int receivedcode ;

  UpdatePasswordEvent({
    required this.email,
    required this.receivedcode,
    required this.verificationCode,
    required this.newPassword,
    
  });

  @override
  List<Object?> get props => [ email , receivedcode , verificationCode, newPassword];
}

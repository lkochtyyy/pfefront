import 'package:equatable/equatable.dart';

import '../../data/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterUser extends AuthEvent {
  final UserModel user;

  RegisterUser(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginUser extends AuthEvent {
  final String email;
  final String password;

  LoginUser(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}
class FetchUserProfile extends AuthEvent {
  final String userId;
  FetchUserProfile(this.userId);
}

import 'package:equatable/equatable.dart';

abstract class UserUpdateEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateNomEvent extends UserUpdateEvent {
  final int userId;
  final String newNom;

  UpdateNomEvent(this.userId, this.newNom);

  @override
  List<Object?> get props => [userId, newNom];
}

class UpdatePrenomEvent extends UserUpdateEvent {
  final int userId;
  final String newPrenom;

  UpdatePrenomEvent(this.userId, this.newPrenom);

  @override
  List<Object?> get props => [userId, newPrenom];
}

class UpdateNumTelEvent extends UserUpdateEvent {
  final int userId;
  final String newNumTel;

  UpdateNumTelEvent(this.userId, this.newNumTel);

  @override
  List<Object?> get props => [userId, newNumTel];
}

class UpdatePasswordevent extends UserUpdateEvent {
  final int userId;
  final String newPassword;

  UpdatePasswordevent(this.userId, this.newPassword);

  @override
  List<Object?> get props => [userId, newPassword];
}

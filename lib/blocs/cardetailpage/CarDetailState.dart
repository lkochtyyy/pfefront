import 'package:pfefront/data/models/announcement_model.dart';

abstract class CarDetailState {}

class CarDetailInitial extends CarDetailState {}

class CarDetailLoading extends CarDetailState {}

class CarDetailLoaded extends CarDetailState {
  final CarAnnouncement announcement;

  CarDetailLoaded(this.announcement);
}

class CarDetailError extends CarDetailState {
  final String message;

  CarDetailError(this.message);
}

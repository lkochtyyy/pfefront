part of 'car_announcement_bloc.dart';

abstract class CarAnnouncementState extends Equatable {
  const CarAnnouncementState();

  @override
  List<Object> get props => [];
}

class CarAnnouncementInitial extends CarAnnouncementState {}

class CarAnnouncementLoading extends CarAnnouncementState {}

class CarAnnouncementLoaded extends CarAnnouncementState {
  final List<CarAnnouncement> announcements;

  const CarAnnouncementLoaded(this.announcements);

  @override
  List<Object> get props => [announcements];
}

class AnnouncementCreated extends CarAnnouncementState {}

class AnnouncementDeleted extends CarAnnouncementState {}

class CarAnnouncementError extends CarAnnouncementState {
  final String error;

  const CarAnnouncementError(this.error);

  @override
  List<Object> get props => [error];
}
class VendorAnnouncementsLoading extends CarAnnouncementState {}

class VendorAnnouncementsLoaded extends CarAnnouncementState {
  final List<CarAnnouncement> announcements;

  const VendorAnnouncementsLoaded(this.announcements);

  @override
  List<Object> get props => [announcements];
}
class VendorAnnouncementsError extends CarAnnouncementState {
  final String message;

  const VendorAnnouncementsError(this.message);

  @override
  List<Object> get props => [message]; // Ajout pour Equatable
}
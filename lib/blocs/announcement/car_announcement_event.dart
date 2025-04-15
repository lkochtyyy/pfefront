part of 'car_announcement_bloc.dart';

abstract class CarAnnouncementEvent extends Equatable {
  const CarAnnouncementEvent();

  @override
  List<Object> get props => [];
}

class FetchAnnouncements extends CarAnnouncementEvent {}

class CreateAnnouncement extends CarAnnouncementEvent {
  final CarAnnouncement announcement;
  final File imageFile;

  const CreateAnnouncement({
    required this.announcement,
    required this.imageFile,
  });

  @override
  List<Object> get props => [announcement, imageFile];
}

class DeleteAnnouncement extends CarAnnouncementEvent {
  final int id;

  const DeleteAnnouncement(this.id);

  @override
  List<Object> get props => [id];
}
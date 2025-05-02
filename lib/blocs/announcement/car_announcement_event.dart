part of 'car_announcement_bloc.dart';

abstract class CarAnnouncementEvent extends Equatable {
  const CarAnnouncementEvent();

  @override
  List<Object> get props => [];
}

class FetchAnnouncements extends CarAnnouncementEvent {
  
}

class CreateAnnouncement extends CarAnnouncementEvent {
  final CarAnnouncement announcement;
  final File imageFile;
  final String userId; 

  const CreateAnnouncement({
    required this.announcement,
    required this.imageFile,
    required this.userId,
  });

  @override
  List<Object> get props => [announcement, imageFile];
}

class DeleteAnnouncement extends CarAnnouncementEvent {
  final String id;
  final String userId;

  DeleteAnnouncement(this.id, this.userId);

  @override
  List<Object> get props => [id, userId];
}
class FetchVendorAnnouncement extends CarAnnouncementEvent {
  final int vendorId;

  FetchVendorAnnouncement(this.vendorId);
}
class UpdateAnnouncement extends CarAnnouncementEvent {
  final Map<String, dynamic> updatedData;

  UpdateAnnouncement(this.updatedData);

  @override
  List<Object> get props => [updatedData];
}
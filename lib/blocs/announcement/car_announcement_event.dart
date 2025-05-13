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
  final String userId;


  const CreateAnnouncement({
    required this.announcement,
    required this.imageFile,
    required this.userId,
  });


  @override
  List<Object> get props => [announcement, imageFile, userId];
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


  @override
  List<Object> get props => [vendorId];
}


class UpdateAnnouncement extends CarAnnouncementEvent {
  final Map<String, dynamic> updatedData;
  final File? imageFile;


  UpdateAnnouncement({required this.updatedData, this.imageFile});


  @override
  List<Object> get props => [updatedData, imageFile ?? ''];
}


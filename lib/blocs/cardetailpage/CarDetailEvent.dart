abstract class CarDetailEvent {}

class LoadCarDetail extends CarDetailEvent {
  final int announcementId;

  LoadCarDetail(this.announcementId);
}
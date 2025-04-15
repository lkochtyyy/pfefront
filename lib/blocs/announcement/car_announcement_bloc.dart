import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pfefront/data/models/announcement_model.dart';
import 'package:pfefront/data/repositories/announcement_repository.dart';

part 'car_announcement_event.dart';
part 'car_announcement_state.dart';

class CarAnnouncementBloc
    extends Bloc<CarAnnouncementEvent, CarAnnouncementState> {
  final CarAnnouncementRepository repository;

  CarAnnouncementBloc({required this.repository})
      : super(CarAnnouncementInitial()) {
    on<FetchAnnouncements>(_onFetch);
    on<CreateAnnouncement>(_onCreate);
    on<DeleteAnnouncement>(_onDelete);
  }

  Future<void> _onFetch(
      FetchAnnouncements event, Emitter<CarAnnouncementState> emit) async {
    emit(CarAnnouncementLoading());
    try {
      final announcements = await repository.fetchAll();
      emit(CarAnnouncementLoaded(announcements));
    } catch (e) {
      emit(CarAnnouncementError(e.toString()));
    }
  }

  Future<void> _onCreate(
      CreateAnnouncement event, Emitter<CarAnnouncementState> emit) async {
    emit(CarAnnouncementLoading());
    try {
      await repository.create(event.announcement, event.imageFile);
      emit(AnnouncementCreated());
      add(FetchAnnouncements());
    } catch (e) {
      emit(CarAnnouncementError('Failed to create announcement: ${e.toString()}'));
    }
  }

  Future<void> _onDelete(
      DeleteAnnouncement event, Emitter<CarAnnouncementState> emit) async {
    emit(CarAnnouncementLoading());
    try {
      await repository.deleteAnnouncement(event.id);
      emit(AnnouncementDeleted());
      add(FetchAnnouncements());
    } catch (e) {
      emit(CarAnnouncementError(e.toString()));
    }
  }
}
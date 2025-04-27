import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfefront/blocs/cardetailpage/CarDetailEvent.dart';
import 'package:pfefront/blocs/cardetailpage/CarDetailState.dart';
import 'package:pfefront/data/repositories/announcement_repository.dart';

class CarDetailBloc extends Bloc<CarDetailEvent, CarDetailState> {
  final CarAnnouncementRepository repository;

  CarDetailBloc({required this.repository}) : super(CarDetailInitial()) {
    on<LoadCarDetail>(_onLoadCarDetail);
  }

  Future<void> _onLoadCarDetail(
    LoadCarDetail event,
    Emitter<CarDetailState> emit,
  ) async {
    emit(CarDetailLoading());

    try {
      final announcement = await repository.fetchById(event.announcementId);
      
      emit(CarDetailLoaded(announcement));
    } catch (e) {
      emit(CarDetailError(e.toString()));
    }
  }
}

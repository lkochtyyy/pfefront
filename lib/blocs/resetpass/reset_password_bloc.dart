import 'package:flutter_bloc/flutter_bloc.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';
import '../../data/repositories/forgetpass_repository.dart';


class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ForgetpassRepository forgetpassword;

  ResetPasswordBloc({required this.forgetpassword}) : super(ResetPasswordInitial()) { // Correction de l'affectation
    on<SendResetCodeEvent>(_onResetPasswordRequest);
    on<UpdatePasswordEvent>(_onUpdatePassword);
  }

 
  Future<void> _onResetPasswordRequest(
      SendResetCodeEvent event, Emitter<ResetPasswordState> emit) async {
    emit(ResetPasswordLoading());
    try {
      final response = await forgetpassword.requestPasswordReset(event.email);
      final message = response['message'];
      final receivedcode = response['verificationCode'];
      emit(ResetPasswordSuccess(message, receivedcode));
      
    } catch (e) {
      emit(ResetPasswordFailure(e.toString()));
    }
  }
  // Step 3: Handle updating the password after verification
  Future<void> _onUpdatePassword(
      UpdatePasswordEvent event, Emitter<ResetPasswordState> emit) async {
    emit(ResetPasswordLoading());
    try {
      final response = await forgetpassword.resetpassword(event.email ,event.receivedcode,event.verificationCode, event.newPassword);
      emit(ResetPassSuccess(response['message']));
    } catch (e) {
      emit(ResetPasswordFailure(e.toString()));
    }
  }
}

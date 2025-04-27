import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfefront/blocs/auth/auth_bloc.dart';
import 'package:pfefront/blocs/resetpass/reset_password_bloc.dart';
import 'package:pfefront/blocs/announcement/car_announcement_bloc.dart'; // Import ajouté
import 'package:pfefront/blocs/userupdate/user_update_bloc.dart';
import 'package:pfefront/data/repositories/auth_repository.dart';
import 'package:pfefront/data/repositories/forgetpass_repository.dart';
import 'package:pfefront/data/repositories/announcement_repository.dart';
import 'package:pfefront/pages/pass1.dart'; // Import ajouté
import 'package:pfefront/data/repositories/user_repository.dart';

void main() {
  final AuthRepository authRepository = AuthRepository();
  final ForgetpassRepository forgetpassword = ForgetpassRepository();
  final CarAnnouncementRepository announcementRepository = CarAnnouncementRepository(dio: Dio()); // Initialisation

  runApp(MyApp(
    authRepository: authRepository,
    forgetpassword: forgetpassword,
    announcementRepository: announcementRepository, // Ajouté
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ForgetpassRepository forgetpassword;
  final CarAnnouncementRepository announcementRepository; // Ajouté

  const MyApp({
    super.key,
    required this.authRepository,
    required this.forgetpassword,
    required this.announcementRepository, // Ajouté
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
        BlocProvider<ResetPasswordBloc>(
          create: (context) => ResetPasswordBloc(forgetpassword: forgetpassword),
        ),
        // Nouveau BlocProvider pour CarAnnouncementBloc
        BlocProvider<CarAnnouncementBloc>(
          create: (context) => CarAnnouncementBloc(
            repository: announcementRepository,
          ),
        ),
         BlocProvider<UserUpdateBloc>(
          create: (context) => UserUpdateBloc(
             UserRepository(),
          ),
        ),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const OnboardingScreen(),
      ),
    );
  }
}
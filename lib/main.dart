import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfefront/blocs/auth/auth_bloc.dart';
import 'package:pfefront/blocs/favoris/favori_bloc.dart';
import 'package:pfefront/blocs/resetpass/reset_password_bloc.dart';
import 'package:pfefront/blocs/announcement/car_announcement_bloc.dart';
import 'package:pfefront/blocs/userupdate/user_update_bloc.dart';
import 'package:pfefront/data/repositories/FavoriRepository.dart';
import 'package:pfefront/data/repositories/auth_repository.dart';
import 'package:pfefront/data/repositories/forgetpass_repository.dart';
import 'package:pfefront/data/repositories/announcement_repository.dart';
import 'package:pfefront/pages/pass1.dart';
import 'package:pfefront/data/repositories/user_repository.dart';

void main() {
  final AuthRepository authRepository = AuthRepository();
  final ForgetpassRepository forgetpassword = ForgetpassRepository();
  final CarAnnouncementRepository announcementRepository =
      CarAnnouncementRepository(dio: Dio());
  final FavoriRepository favoriRepository = FavoriRepository();

  runApp(MyApp(
    authRepository: authRepository,
    forgetpassword: forgetpassword,
    announcementRepository: announcementRepository,
    favoriRepository: favoriRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ForgetpassRepository forgetpassword;
  final CarAnnouncementRepository announcementRepository; // Ajouté
  final FavoriRepository favoriRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.forgetpassword,
    required this.announcementRepository, // Ajouté
    required this.favoriRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<ForgetpassRepository>.value(value: forgetpassword),
        RepositoryProvider<CarAnnouncementRepository>.value(
            value: announcementRepository),
        RepositoryProvider<FavoriRepository>.value(value: favoriRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: authRepository),
          ),
          BlocProvider<ResetPasswordBloc>(
            create: (context) =>
                ResetPasswordBloc(forgetpassword: forgetpassword),
          ),
          BlocProvider<CarAnnouncementBloc>(
            create: (context) =>
                CarAnnouncementBloc(repository: announcementRepository),
          ),
          BlocProvider<UserUpdateBloc>(
            create: (context) => UserUpdateBloc(UserRepository()),
          ),
          BlocProvider<FavoriBloc>(
            create: (context) => FavoriBloc(
              context.read<
                  FavoriRepository>(), // ✅ On utilise le contexte ici proprement
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const OnboardingScreen(),
        ),
      ),
    );
  }
}

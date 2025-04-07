import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pfefront/blocs/resetpass/reset_password_bloc.dart';
import 'package:pfefront/data/repositories/forgetpass_repository.dart';
import 'package:pfefront/pages/pass1.dart';
import 'blocs/auth/auth_bloc.dart';
import 'data/repositories/auth_repository.dart';


void main() {
  final AuthRepository authRepository = AuthRepository();
  final ForgetpassRepository forgetpassword = ForgetpassRepository(); 

  runApp(MyApp(authRepository: authRepository,forgetpassword: forgetpassword));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ForgetpassRepository forgetpassword ;
  const MyApp({super.key, required this.forgetpassword ,required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository),
         
        ),
        BlocProvider<ResetPasswordBloc>(
          create: (context) => ResetPasswordBloc(forgetpassword: forgetpassword,),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (context) => const OnboardingScreen(),          
            },
          );
        },
      ),
    );
  }
}

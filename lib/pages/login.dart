import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pfefront/blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import 'pagedacceuil.dart';
import 'forgetpassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  IconData _suffixIcon = Icons.visibility_off;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F3), // Light background color
      body: Stack(
        children: [
          // Background shape (using shape.png)
          Positioned(
            top: -size.height * 0.05,
            left: -size.width * 0.05,
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                'assets/shape.png', // Path to your shape.png image
                width: size.width * 0.6,
                fit: BoxFit.cover, // Adjust to fit the screen
              ),
            ),
          ),
          // Main content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLoading) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logging in...')),
                      );
                    } else if (state is LoginSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login Successful!')),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeaturedCarsPage(userId: state.userId),
                        ),
                      );
                    } else if (state is AuthFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 160),
                      Image.asset(
                        'assets/beepbeep.png',
                        width: 350,
                      ),
                      const SizedBox(height: 50),
                      _buildTextField(
                        controller: _emailController,
                        icon: Icons.person,
                        hintText: 'Username or Email',
                        obscureText: false,
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _passwordController,
                        icon: Icons.lock,
                        hintText: 'Password',
                        obscureText: _obscureText,
                        suffixIcon: _suffixIcon,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  LoginUser(
                                    _emailController.text,
                                    _passwordController.text,
                                  ),
                                );
                          }
                        },
                        
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF50C2C9), // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 150),
                          elevation: 6,
                        ),
                        
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    required bool obscureText,
    IconData? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey.shade700),
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                  onTap: _togglePasswordVisibility,
                  child: Icon(
                    suffixIcon,
                    color: Colors.grey.shade700,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
      _suffixIcon = _obscureText ? Icons.visibility_off : Icons.visibility;
    });
  }
}

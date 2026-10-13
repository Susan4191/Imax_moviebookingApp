import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/AdminScreens/admin_dashboard_screen.dart';
import 'package:imax_movie_ticket_booking/BoxOfficeScreens/box_office_booking_screen.dart';
import 'package:imax_movie_ticket_booking/Services/firebase_app_auth.dart';
import 'package:imax_movie_ticket_booking/SuperAdminScreens/super_admin_dashboard_screen.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';
import 'create_account.dart';
import '../PublicScreens/dashboard_screen.dart';
import 'package:imax_movie_ticket_booking/Widgets/singup_singin_screen.dart';

import '../Widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePassword = true;
  bool isSelected = false;
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final String email = emailController.text.trim().toLowerCase();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppToast.showError('Please enter email and password');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (user != null) {
        final bool isSuperAdmin =
            email.endsWith('@superadmin.com') ||
            (user.email?.toLowerCase().endsWith('@superadmin.com') ?? false);
        final bool isAdmin =
            email.endsWith('@admin.com') ||
            (user.email?.toLowerCase().endsWith('@admin.com') ?? false);
        final bool isBoxOffice =
            email.endsWith('@boxoffice.com') ||
            (user.email?.toLowerCase().endsWith('@boxoffice.com') ?? false);

        if (isSuperAdmin) {
          AppToast.showSuccess('Welcome Super Admin!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const SuperAdminDashboardScreen(),
            ),
          );
        } else if (isAdmin) {
          AppToast.showSuccess('Welcome Cinema Admin!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
          );
        } else if (isBoxOffice) {
          AppToast.showSuccess('Welcome Box Office Counter!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const BoxOfficeBookingScreen()),
          );
        } else {
          AppToast.showSuccess('Logged in successfully!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      AppToast.showError('An error occurred during login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SignUpSignIn(
            titleText: "Login required for booking ticket :",
            label: const ["Email :", "Password :"],
            textField: [
              CostumeTextField(
                hintText: "Enter your email",
                prefixIcon: Icons.email_outlined,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              CostumeTextField(
                hintText: "Enter your password",
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: Icons.lock_outline,
                suffixIcon: hidePassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                onSuffixTap: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                obscureText: hidePassword,
              ),
            ],
            checkBox: isSelected
                ? Icons.check_box
                : Icons.check_box_outline_blank_outlined,
            onCheckTap: () {
              setState(() {
                isSelected = !isSelected;
              });
            },
            rTC: "Remember me",
            forgotText: "Forgot Password ?",
            onForgotTap: () {
              AppToast.showInfo('Password reset link sent to your email');
            },
            buttonText: isLoading ? "Logging in..." : "LogIn",
            onButtonTap: () {
              if (!isLoading) {
                _handleLogin();
              }
            },
            dividerText: "Or SignIn With",
            accountText: "Don't have an account? ",
            signText: "SignUp",
            onSingTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateAccount()),
              );
            },
          ),
          if (isLoading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}

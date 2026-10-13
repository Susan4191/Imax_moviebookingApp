import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/Services/firebase_app_auth.dart';
import 'package:imax_movie_ticket_booking/Widgets/terms_conditions_card.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';
import 'login_screen.dart';

import '../Widgets/custom_text_field.dart';
import '../Widgets/singup_singin_screen.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isSelected = false;
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conformPasswordController =
      TextEditingController();

  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    conformPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateAccount() async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = conformPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      AppToast.showError('Please fill in all required fields');
      return;
    }

    final String emailLower = email.toLowerCase();
    if (emailLower.endsWith('@superadmin.com') ||
        emailLower.endsWith('@admin.com') ||
        emailLower.endsWith('@boxoffice.com') ||
        emailLower.contains('superadmin.com') ||
        emailLower.contains('admin.com') ||
        emailLower.contains('boxoffice.com')) {
      AppToast.showError(
        'Restricted! Admin and Box Office accounts cannot be created from the Sign Up screen.',
      );
      return;
    }

    if (password != confirmPassword) {
      AppToast.showError('Passwords do not match');
      return;
    }

    if (password.length < 6) {
      AppToast.showError('Password must be at least 6 characters');
      return;
    }

    if (!isSelected) {
      AppToast.showError('Please accept the Terms and Conditions to proceed');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final user = await _authService.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (user != null) {
      AppToast.showSuccess('Account created successfully! Please log in.');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SignUpSignIn(
            titleText: "Create An Account:",
            label: const ["Name:", "Email:", "Password:", "Conform Password:"],
            textField: [
              CostumeTextField(
                hintText: "Enter Your Full Name",
                prefixIcon: Icons.person,
                controller: nameController,
              ),
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
              CostumeTextField(
                hintText: "Conform Your password",
                controller: conformPasswordController,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: Icons.lock_outline,
                suffixIcon: hideConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                onSuffixTap: () {
                  setState(() {
                    hideConfirmPassword = !hideConfirmPassword;
                  });
                },
                obscureText: hideConfirmPassword,
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
            rTC: "Terms and Conditions",
            onRtcTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) {
                  return TermsAndConditionsDialog(
                    onAccept: () {
                      setState(() {
                        isSelected = true;
                      });
                    },
                  );
                },
              );
            },
            forgotText: "Forgot Password ?",
            onForgotTap: () {
              AppToast.showInfo('Password reset link sent');
            },
            buttonText: isLoading ? "Creating Account..." : "Create An Account",
            onButtonTap: () {
              if (!isLoading) {
                _handleCreateAccount();
              }
            },
            dividerText: "Or SignIn With",
            accountText: "Already have an account? ",
            signText: "LogIn",
            onSingTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
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

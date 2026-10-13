import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/AdminScreens/admin_dashboard_screen.dart';
import 'package:imax_movie_ticket_booking/BoxOfficeScreens/box_office_booking_screen.dart';
import 'package:imax_movie_ticket_booking/Services/firebase_app_auth.dart';
import 'package:imax_movie_ticket_booking/SuperAdminScreens/super_admin_dashboard_screen.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_text_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart';
import 'on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAppStartRoute();
  }

  Future<void> _checkAppStartRoute() async {
    // Show splash screen with progress indicator for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    final user = FirebaseAuthService().currentUser;
    final String? savedRole = prefs.getString('userRole');

    if (!mounted) return;

    if (isFirstTime) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnBoardingScreen()),
      );
    } else {
      // Direct user to dedicated dashboard screen based on role or session
      if (user != null) {
        final String email = (user.email ?? '').toLowerCase();

        if (email.endsWith('@superadmin.com') || savedRole == 'super_admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const SuperAdminDashboardScreen(),
            ),
          );
        } else if (email.endsWith('@admin.com') || savedRole == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
          );
        } else if (email.endsWith('@boxoffice.com') ||
            savedRole == 'box_office') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const BoxOfficeBookingScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/images/splash_screen.png",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: AppColor.backgroundColor),
            ),
          ),
          Positioned(
            bottom: 120.0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: AppColor.themeColor,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 14),
                Text(
                  'Loading...',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColor.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

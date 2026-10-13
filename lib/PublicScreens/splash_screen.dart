import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
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

  void checkFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (!mounted) return;

    if (isFirstTime) {
      navigateToOnboardingScreen();
    } else {
      navigateToDashboard();
    }
  }

  void navigateToOnboardingScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
    );
  }

  void navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  void initState() {
    checkFirstTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            ///Background Image
            child: Image(
              image: AssetImage("assets/images/splash_screen.png"),
              fit: BoxFit.cover,
            ),
          ),

          ///Loading
          const SizedBox(height: 20),
          if (isLoading)
            Positioned(
              bottom:
                  150.0, // Places the widget 50 pixels up from the very bottom of the screen
              left: 0,
              right: 0,
              child: Center(
                child: CircularProgressIndicator(color: AppColor.themeColor),
              ),
            ),
        ],
      ),
    );
  }
}

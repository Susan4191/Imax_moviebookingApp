import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../LoginSignAccountScreen/login_screen.dart';
import 'package:imax_movie_ticket_booking/Widgets/gesture_getector_button.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_text_style.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          ///Background Image
          Image.asset("assets/images/on_boarding_blank.png", fit: BoxFit.cover),
          Align(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Top Logo
                    Image.asset("assets/images/logo.png", scale: 10),

                    Column(
                      children: [
                        ///Text
                        Text(
                          "WELCOME TO IMAXNP",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColor.red,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Text(
                          "Your Cinema. Your Movie.",
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColor.white,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Text(
                          "Discover the latest movies, choose your perfect.",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColor.grey,
                          ),
                        ),
                        Text(
                          "showtime, and book the seats you love-all in one place.",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColor.grey,
                          ),
                        ),
                        const SizedBox(height: 15),

                        ///icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  "assets/images/discover.png",
                                  scale: 10,
                                ),
                                Text(
                                  "Discover",
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColor.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 80,
                              child: VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: AppColor.red,
                              ),
                            ),

                            //
                            Column(
                              children: [
                                Image.asset(
                                  "assets/images/choose.png",
                                  scale: 10,
                                ),
                                Text(
                                  "Choose",
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColor.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 80,
                              child: VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: AppColor.red,
                              ),
                            ),

                            //
                            Column(
                              children: [
                                Image.asset(
                                  "assets/images/book.png",
                                  scale: 10,
                                ),
                                Text(
                                  "Book",
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColor.white,
                                  ),
                                ),
                              ],
                            ),

                            //
                          ],
                        ),
                        const SizedBox(height: 15),

                        ///Navigate to homescreen
                        GestureDetectorButton(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DashboardScreen(),
                              ),
                            );
                          },
                          gestureText: "Explore Movies",
                        ),

                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColor.grey,
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "LogIn",
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColor.themeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

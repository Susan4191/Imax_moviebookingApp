import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/Widgets/gesture_getector_button.dart';

import '../utils/app_color.dart';
import '../utils/app_text_style.dart';

class SignUpSignIn extends StatelessWidget {
  const SignUpSignIn({
    super.key,
    required this.titleText,
    required this.label,
    required this.textField,
    required this.checkBox,
    required this.onCheckTap,
    required this.rTC,
    this.onRtcTap,
    this.forgotText,
    this.onForgotTap,
    required this.buttonText,
    required this.onButtonTap,
    required this.dividerText,
    required this.accountText,
    required this.signText,
    required this.onSingTap,
  });

  final String titleText;
  final List<String> label;
  final List<Widget> textField;
  final IconData checkBox;
  final String rTC;
  final VoidCallback? onRtcTap;
  final String buttonText;
  final VoidCallback onButtonTap;
  final VoidCallback onCheckTap;
  final String? forgotText;
  final VoidCallback? onForgotTap;
  final String dividerText;
  final String accountText;
  final String signText;
  final VoidCallback onSingTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,

      children: [
        ///Background Image
        Image.asset("assets/images/blank_background.png", fit: BoxFit.cover),
        Align(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ///Logo image
                  Center(
                    child: Image.asset("assets/images/logo.png", scale: 7),
                  ),
                  const SizedBox(height: 10),

                  //
                  Text(
                    titleText,
                    style: AppTextStyles.headingMedium.copyWith(
                      color: AppColor.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColor.cardColor.withValues(alpha: 0.90),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColor.borderColor, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.themeColor.withValues(alpha: 0.12),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ...List.generate(
                          textField.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  label[index],
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColor.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                textField[index],
                              ],
                            ),
                          ),
                        ),

                        /// Terms and Condition And Forget Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: onCheckTap,
                                  child: Icon(
                                    checkBox,
                                    size: 15,
                                    color: AppColor.themeColor,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: onRtcTap,
                                  child: Text(
                                    rTC,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColor.themeColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: onForgotTap,
                              child: Text(
                                forgotText ?? "",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColor.themeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  ///GestureDetectorButton
                  GestureDetectorButton(
                    gestureText: buttonText,
                    onTap: onButtonTap,
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: AppColor.themeColor,
                        ),
                      ),
                      Text(
                        dividerText,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColor.textSecondary,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: AppColor.themeColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  //
                  Column(
                    children: [
                      // Social login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google
                          GestureDetector(
                            onTap: () {
                              // Add Google login here
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColor.inputColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColor.borderColor),
                              ),
                              child: Image.asset(
                                "assets/images/google_logo_transparent.png",
                                scale: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),

                          // Facebook
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: (context),
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: AppColor.cardColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(
                                        color: AppColor.borderColor,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColor.inputColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColor.borderColor),
                              ),
                              child: Image.asset(
                                "assets/images/facebook_logo_transparent.png",
                                scale: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Sign-up option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            accountText,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColor.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: onSingTap,
                            child: Text(
                              signText,
                              style: AppTextStyles.labelMedium.copyWith(
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
    );
  }
}

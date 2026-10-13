import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';

import '../Widgets/custom_app_bar.dart';
import '../Widgets/profile_card.dart';
import '../Widgets/terms_conditions_card.dart';
import '../utils/app_text_style.dart';
import '../utils/app_toast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

void showAboutApp(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: AppColor.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: AppColor.borderColor),
        ),
        title: Text(
          'About IMAXNP',
          style: AppTextStyles.headingSmall.copyWith(color: AppColor.white),
        ),
        content: Text('''
IMAXNP is a movie-ticket booking application.

Users can browse movies, select showtimes, choose available seats, make payments and manage their bookings.

The application makes cinema ticket booking simple, fast and convenient.
''', style: AppTextStyles.bodyMedium.copyWith(color: AppColor.grey)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: Text(
              'Close',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColor.themeColor,
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColor.white,
                ),
              ),

              const SizedBox(height: 10),

              /// Profile information
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.borderColor),
                ),
                child: Row(
                  children: [
                    /// Generic Avatar Icon
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: AppColor.themeColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.themeColor,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColor.themeColor,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 15),

                    /// User information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "User Profile",
                            style: AppTextStyles.titleMedium.copyWith(
                              color: AppColor.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Connect account or complete profile',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColor.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// Personal information
              ProfileCard(
                icon: Icons.person_outline,
                title: 'Personal Information',
                subtitle: 'Name, email and phone number',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  );
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),

              ///Terms and Conditions
              ProfileCard(
                icon: Icons.description_outlined,
                title: 'Terms and Conditions',
                subtitle: 'Read our terms and policies',
                onTap: () {
                  showDialog(
                    context: (context),
                    builder: (_) => TermsAndConditionsDialog(),
                  );
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),

              ///About App
              ProfileCard(
                icon: Icons.info_outline,
                title: 'About App',
                subtitle: 'Information about IMAXNP',
                onTap: () {
                  showAboutApp(context);
                },
              ),

              const SizedBox(height: 10),

              ///App Version
              ProfileCard(
                icon: Icons.system_update_outlined,
                title: 'App Version',
                trailingText: '1.0.0',
                onTap: () {
                  AppToast.showInfo('You are using the latest version v1.0.0');
                },
              ),
              const SizedBox(height: 10),

              ///Logout
              ProfileCard(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  AppToast.showInfo('Logged out successfully');
                },
              ),
              const SizedBox(height: 10),

              ///Delete Account
              ProfileCard(
                icon: Icons.delete_forever_outlined,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                iconColor: AppColor.red,
                titleColor: AppColor.red,
                borderColor: AppColor.red,
                onTap: () {
                  AppToast.showError('Account deletion request submitted');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

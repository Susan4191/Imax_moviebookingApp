import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/LoginSignAccountScreen/login_screen.dart';
import 'package:imax_movie_ticket_booking/Services/firebase_app_auth.dart';
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
  void initState() {
    super.initState();
    _reloadUser();
  }

  Future<void> _reloadUser() async {
    final user = FirebaseAuthService().currentUser;
    if (user != null) {
      try {
        await user.reload();
      } catch (_) {}
      if (mounted) {
        setState(() {});
      }
    }
  }

  String _getFormattedUserName(User? user) {
    if (user == null) return 'Guest User';

    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      return user.displayName!.trim();
    }

    if (user.email != null && user.email!.trim().isNotEmpty) {
      final String prefix = user.email!.split('@').first;
      final words = prefix.replaceAll(RegExp(r'[_.-]'), ' ').split(' ');
      final formatted = words
          .where((w) => w.isNotEmpty)
          .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
          .join(' ');
      if (formatted.isNotEmpty) {
        return formatted;
      }
    }

    return 'Guest User';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuthService().currentUser;
    final String displayName = _getFormattedUserName(user);
    final String email = user?.email ?? 'Not Logged In';

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
                    /// User Avatar Circle
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
                      child: Center(
                        child: Text(
                          displayName.isNotEmpty
                              ? displayName[0].toUpperCase()
                              : 'U',
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColor.themeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),

                    /// User information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: AppColor.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            email,
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
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  );
                  if (mounted) {
                    setState(() {});
                  }
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
                    context: context,
                    builder: (_) => const TermsAndConditionsDialog(),
                  );
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
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (dialogCtx) => AlertDialog(
                      backgroundColor: AppColor.cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        'Logout',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to log out of your account?',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColor.textSecondary,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogCtx),
                          child: Text(
                            'Cancel',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColor.grey,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(dialogCtx);
                            await FirebaseAuthService().signOut();
                            AppToast.showInfo('Logged out successfully');
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.themeColor,
                          ),
                          child: Text(
                            'Logout',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColor.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
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
                  showDialog(
                    context: context,
                    builder: (dialogCtx) => AlertDialog(
                      backgroundColor: AppColor.cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        'Delete Account',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColor.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to permanently delete your account? This action cannot be undone.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColor.textSecondary,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogCtx),
                          child: Text(
                            'Cancel',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColor.grey,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(dialogCtx);
                            try {
                              final currentUser =
                                  FirebaseAuthService().currentUser;
                              if (currentUser != null) {
                                await currentUser.delete();
                              }
                            } catch (_) {}
                            await FirebaseAuthService().signOut();
                            AppToast.showSuccess(
                              'Account deleted successfully',
                            );
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.red,
                          ),
                          child: Text(
                            'Delete',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColor.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

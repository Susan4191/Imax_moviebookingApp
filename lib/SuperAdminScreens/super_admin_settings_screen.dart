import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/LoginSignAccountScreen/login_screen.dart';
import 'package:imax_movie_ticket_booking/Provider/super_admin_provider.dart';
import 'package:imax_movie_ticket_booking/PublicScreens/dashboard_screen.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_text_style.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';
import 'package:provider/provider.dart';

class SuperAdminSettingsScreen extends StatelessWidget {
  const SuperAdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final superAdminProvider = context.watch<SuperAdminProvider>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Text(
                'Super Admin Settings',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Manage account profile, system configurations, and platform controls',
                style: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
              ),

              const SizedBox(height: 20),

              /// Profile Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.borderColor),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColor.themeColor,
                      child: Text(
                        superAdminProvider.superAdminName.isNotEmpty
                            ? superAdminProvider.superAdminName[0].toUpperCase()
                            : 'S',
                        style: AppTextStyles.headingMedium.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                superAdminProvider.superAdminName,
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColor.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.themeColor.withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: AppColor.themeColor,
                                  ),
                                ),
                                child: Text(
                                  'SUPER ADMIN',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColor.themeColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            superAdminProvider.superAdminEmail,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColor.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    OutlinedButton.icon(
                      onPressed: () => _showEditProfileDialog(context),
                      icon: const Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: AppColor.white,
                      ),
                      label: Text(
                        'Edit Profile',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColor.white,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColor.borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// System Configuration Toggles Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Platform Controls',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SwitchListTile(
                      value: superAdminProvider.maintenanceMode,
                      activeThumbColor: AppColor.themeColor,
                      title: Text(
                        'System Maintenance Mode',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColor.white,
                        ),
                      ),
                      subtitle: Text(
                        'Temporarily pause new customer ticket bookings across all screens',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColor.grey,
                        ),
                      ),
                      onChanged: (val) {
                        context.read<SuperAdminProvider>().setMaintenanceMode(
                          val,
                        );
                        AppToast.showInfo(
                          val
                              ? 'Maintenance Mode Enabled'
                              : 'Maintenance Mode Disabled',
                        );
                      },
                    ),

                    const Divider(color: AppColor.borderColor),

                    SwitchListTile(
                      value: superAdminProvider.allowWalkInBooking,
                      activeThumbColor: AppColor.green,
                      title: Text(
                        'Box Office Walk-In Counter Feature',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColor.white,
                        ),
                      ),
                      subtitle: Text(
                        'Allow cinema staff to issue walk-in printed tickets from Box Office tab',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColor.grey,
                        ),
                      ),
                      onChanged: (val) {
                        context
                            .read<SuperAdminProvider>()
                            .setAllowWalkInBooking(val);
                        AppToast.showInfo(
                          val
                              ? 'Box Office feature active'
                              : 'Box Office feature disabled',
                        );
                      },
                    ),

                    const Divider(color: AppColor.borderColor),

                    SwitchListTile(
                      value: superAdminProvider.systemNotifications,
                      activeThumbColor: AppColor.blue,
                      title: Text(
                        'System Alert Notifications',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColor.white,
                        ),
                      ),
                      subtitle: Text(
                        'Receive real-time notifications for new bookings and cancellations',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColor.grey,
                        ),
                      ),
                      onChanged: (val) {
                        context
                            .read<SuperAdminProvider>()
                            .setSystemNotifications(val);
                        AppToast.showInfo(
                          val
                              ? 'Notifications enabled'
                              : 'Notifications disabled',
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Security & Account Actions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Security & Quick Actions',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ListTile(
                      leading: const Icon(
                        Icons.lock_reset_rounded,
                        color: AppColor.themeColor,
                      ),
                      title: Text(
                        'Change Password',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColor.white,
                        ),
                      ),
                      subtitle: Text(
                        'Update your Super Admin access credentials',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColor.grey,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppColor.grey,
                      ),
                      onTap: () => _showChangePasswordDialog(context),
                    ),

                    const Divider(color: AppColor.borderColor),

                    ListTile(
                      leading: const Icon(
                        Icons.smartphone_rounded,
                        color: AppColor.blue,
                      ),
                      title: Text(
                        'Switch to Customer App',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColor.white,
                        ),
                      ),
                      subtitle: Text(
                        'View the app from the customer perspective',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColor.grey,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppColor.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DashboardScreen(),
                          ),
                        );
                      },
                    ),

                    const Divider(color: AppColor.borderColor),

                    ListTile(
                      leading: const Icon(
                        Icons.logout_rounded,
                        color: AppColor.red,
                      ),
                      title: Text(
                        'Logout Super Admin',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColor.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Terminate current Super Admin session securely',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColor.grey,
                        ),
                      ),
                      onTap: () => _confirmLogout(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final superAdminProvider = context.read<SuperAdminProvider>();
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(
      text: superAdminProvider.superAdminName,
    );
    final emailController = TextEditingController(
      text: superAdminProvider.superAdminEmail,
    );

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColor.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Edit Super Admin Profile',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: 360,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Name is required' : null,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColor.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: AppTextStyles.bodySmall.copyWith(
                      color: AppColor.grey,
                    ),
                    filled: true,
                    fillColor: AppColor.backgroundColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColor.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColor.themeColor),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Email is required'
                      : null,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColor.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: AppTextStyles.bodySmall.copyWith(
                      color: AppColor.grey,
                    ),
                    filled: true,
                    fillColor: AppColor.backgroundColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColor.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColor.themeColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelMedium.copyWith(color: AppColor.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<SuperAdminProvider>().updateSuperAdminProfile(
                  nameController.text.trim(),
                  emailController.text.trim(),
                );
                Navigator.pop(dialogCtx);
                AppToast.showSuccess('Super Admin Profile Updated');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.themeColor,
            ),
            child: Text(
              'Save',
              style: AppTextStyles.labelMedium.copyWith(color: AppColor.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColor.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Change Password',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: 360,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: oldPasswordController,
                  obscureText: true,
                  validator: (v) => v == null || v.isEmpty
                      ? 'Current password required'
                      : null,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColor.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    labelStyle: AppTextStyles.bodySmall.copyWith(
                      color: AppColor.grey,
                    ),
                    filled: true,
                    fillColor: AppColor.backgroundColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColor.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColor.themeColor),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  validator: (v) => v == null || v.length < 6
                      ? 'New password must be at least 6 characters'
                      : null,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColor.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: AppTextStyles.bodySmall.copyWith(
                      color: AppColor.grey,
                    ),
                    filled: true,
                    fillColor: AppColor.backgroundColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColor.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColor.themeColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelMedium.copyWith(color: AppColor.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(dialogCtx);
                AppToast.showSuccess('Password Changed Successfully');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.themeColor,
            ),
            child: Text(
              'Update Password',
              style: AppTextStyles.labelMedium.copyWith(color: AppColor.white),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout Super Admin',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to log out of the Super Admin Panel?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColor.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelMedium.copyWith(color: AppColor.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SuperAdminProvider>().logoutSuperAdmin();
              AppToast.showInfo('Logged out of Super Admin Panel');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.themeColor,
            ),
            child: Text(
              'Logout',
              style: AppTextStyles.labelMedium.copyWith(color: AppColor.white),
            ),
          ),
        ],
      ),
    );
  }
}

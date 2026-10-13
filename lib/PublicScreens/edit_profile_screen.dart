import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/Services/firebase_app_auth.dart';

import '../Widgets/custom_text_field.dart';
import '../utils/app_color.dart';
import '../utils/app_text_style.dart';
import '../utils/app_toast.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    final user = FirebaseAuthService().currentUser;
    if (user != null) {
      nameController.text = user.displayName ?? '';
      emailController.text = user.email ?? '';
      phoneController.text = user.phoneNumber ?? '';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        foregroundColor: AppColor.white,
        elevation: 0,
        title: Text(
          'Personal Information',
          style: AppTextStyles.titleMedium.copyWith(color: AppColor.white),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Generic Profile Avatar
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.themeColor.withValues(alpha: 0.2),
                      border: Border.all(color: AppColor.themeColor, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        nameController.text.trim().isNotEmpty
                            ? nameController.text.trim()[0].toUpperCase()
                            : 'U',
                        style: AppTextStyles.headingMedium.copyWith(
                          color: AppColor.themeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  'Full Name',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColor.white,
                  ),
                ),

                const SizedBox(height: 8),

                CostumeTextField(
                  controller: nameController,
                  hintText: 'Enter your full name',
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                Text(
                  'Email Address',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColor.white,
                  ),
                ),

                const SizedBox(height: 8),

                CostumeTextField(
                  controller: emailController,
                  hintText: 'Enter your email address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                Text(
                  'Phone Number',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColor.white,
                  ),
                ),

                const SizedBox(height: 8),

                CostumeTextField(
                  controller: phoneController,
                  hintText: 'Enter your phone number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your phone number';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState?.validate() == true) {
                        final user = FirebaseAuthService().currentUser;
                        if (user != null) {
                          await user.updateDisplayName(
                            nameController.text.trim(),
                          );
                          await user.reload();
                        }
                        AppToast.showSuccess('Profile updated successfully!');
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } else {
                        AppToast.showError('Please fill required fields');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.themeColor,
                      foregroundColor: AppColor.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

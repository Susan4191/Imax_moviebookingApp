import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/Model/cinema_admin_model.dart';
import 'package:imax_movie_ticket_booking/Provider/super_admin_provider.dart';
import 'package:imax_movie_ticket_booking/Services/firebase_app_auth.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_text_style.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';
import 'package:provider/provider.dart';

class SuperAdminCinemaAdminsScreen extends StatefulWidget {
  const SuperAdminCinemaAdminsScreen({super.key});

  @override
  State<SuperAdminCinemaAdminsScreen> createState() =>
      _SuperAdminCinemaAdminsScreenState();
}

class _SuperAdminCinemaAdminsScreenState
    extends State<SuperAdminCinemaAdminsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final superAdminProvider = context.watch<SuperAdminProvider>();
    final admins = superAdminProvider.filteredCinemaAdmins;

    final activeCount = superAdminProvider.cinemaAdmins
        .where((a) => a.isActive)
        .length;
    final inactiveCount = superAdminProvider.cinemaAdmins
        .where((a) => !a.isActive)
        .length;

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header & Add Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cinema Admin Management',
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Super Admin authorization to create & manage @admin.com accounts',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColor.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  ElevatedButton.icon(
                    onPressed: () => _showCreateCinemaAdminDialog(context),
                    icon: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: AppColor.white,
                      size: 18,
                    ),
                    label: Text(
                      'Create Cinema Admin',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.themeColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Summary Badges
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColor.borderColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColor.green.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_user_rounded,
                              color: AppColor.green,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$activeCount Active Admins',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.titleSmall.copyWith(
                                    color: AppColor.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Granted Full Access',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColor.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColor.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColor.borderColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColor.red.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.gpp_bad_rounded,
                              color: AppColor.red,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$inactiveCount Suspended Admins',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.titleSmall.copyWith(
                                    color: AppColor.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Access Deactivated',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColor.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Search Bar
              TextField(
                controller: _searchController,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColor.white),
                onChanged: (val) {
                  context.read<SuperAdminProvider>().setCinemaAdminSearchQuery(
                    val.trim(),
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search admin by name or email...',
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.grey,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColor.grey),
                  suffixIcon:
                      superAdminProvider.cinemaAdminSearchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColor.grey),
                          onPressed: () {
                            _searchController.clear();
                            context
                                .read<SuperAdminProvider>()
                                .setCinemaAdminSearchQuery('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColor.cardColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColor.themeColor),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Admins List
              Expanded(
                child: admins.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.manage_accounts_outlined,
                              size: 56,
                              color: AppColor.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No cinema admins found',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColor.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Try adjusting your search criteria.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColor.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: admins.length,
                        itemBuilder: (context, index) {
                          final admin = admins[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColor.cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: admin.isActive
                                    ? AppColor.borderColor
                                    : AppColor.red.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: admin.isActive
                                      ? AppColor.themeColor.withValues(
                                          alpha: 0.2,
                                        )
                                      : AppColor.grey.withValues(alpha: 0.2),
                                  child: Icon(
                                    Icons.admin_panel_settings_rounded,
                                    color: admin.isActive
                                        ? AppColor.themeColor
                                        : AppColor.grey,
                                  ),
                                ),
                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              admin.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyles.titleSmall
                                                  .copyWith(
                                                    color: AppColor.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  (admin.isActive
                                                          ? AppColor.green
                                                          : AppColor.red)
                                                      .withValues(alpha: 0.2),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: admin.isActive
                                                    ? AppColor.green
                                                    : AppColor.red,
                                                width: 0.8,
                                              ),
                                            ),
                                            child: Text(
                                              admin.isActive
                                                  ? 'ACTIVE'
                                                  : 'INACTIVE',
                                              style: AppTextStyles.labelSmall
                                                  .copyWith(
                                                    color: admin.isActive
                                                        ? AppColor.green
                                                        : AppColor.red,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        admin.email,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColor.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Transform.scale(
                                      scale: 0.85,
                                      child: Switch(
                                        value: admin.isActive,
                                        activeThumbColor: AppColor.green,
                                        inactiveThumbColor: AppColor.red,
                                        onChanged: (_) {
                                          context
                                              .read<SuperAdminProvider>()
                                              .toggleCinemaAdminStatus(
                                                admin.id,
                                              );
                                          AppToast.showInfo(
                                            admin.isActive
                                                ? 'Admin ${admin.name} suspended'
                                                : 'Admin ${admin.name} activated',
                                          );
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          padding: const EdgeInsets.all(4),
                                          icon: const Icon(
                                            Icons.edit_outlined,
                                            color: AppColor.blue,
                                            size: 18,
                                          ),
                                          onPressed: () =>
                                              _showCreateCinemaAdminDialog(
                                                context,
                                                adminToEdit: admin,
                                              ),
                                          tooltip: 'Edit Admin Details',
                                        ),
                                        const SizedBox(width: 4),
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          padding: const EdgeInsets.all(4),
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: AppColor.red,
                                            size: 18,
                                          ),
                                          onPressed: () => _confirmDeleteAdmin(
                                            context,
                                            admin,
                                          ),
                                          tooltip: 'Delete Admin Account',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteAdmin(BuildContext context, CinemaAdminModel admin) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Cinema Admin',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to permanently delete admin account "${admin.name}" (${admin.email})?',
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
              context.read<SuperAdminProvider>().deleteCinemaAdmin(admin.id);
              Navigator.pop(ctx);
              AppToast.showSuccess('Cinema Admin account removed');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.themeColor,
            ),
            child: Text(
              'Delete Account',
              style: AppTextStyles.labelMedium.copyWith(color: AppColor.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateCinemaAdminDialog(
    BuildContext context, {
    CinemaAdminModel? adminToEdit,
  }) {
    final formKey = GlobalKey<FormState>();
    final isEditing = adminToEdit != null;

    final nameController = TextEditingController(
      text: isEditing ? adminToEdit.name : '',
    );
    final emailController = TextEditingController(
      text: isEditing ? adminToEdit.email : '',
    );
    final passwordController = TextEditingController();
    bool hidePassword = true;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColor.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                isEditing
                    ? Icons.manage_accounts_outlined
                    : Icons.person_add_alt_1_rounded,
                color: AppColor.themeColor,
              ),
              const SizedBox(width: 8),
              Text(
                isEditing ? 'Edit Cinema Admin' : 'Create Cinema Admin',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 380,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormField(
                      controller: nameController,
                      label: 'Admin Name',
                      hint: 'e.g. Binod Shrestha',
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Name is required'
                          : null,
                    ),

                    const SizedBox(height: 12),

                    _buildFormField(
                      controller: emailController,
                      label: 'Admin Email (@admin.com)',
                      hint: 'binod@admin.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                    ),

                    if (!isEditing) ...[
                      const SizedBox(height: 12),
                      _buildFormField(
                        controller: passwordController,
                        label: 'Password',
                        hint: '••••••••',
                        obscureText: hidePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColor.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            setDialogState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        ),
                        validator: (v) => v == null || v.trim().length < 6
                            ? 'Min 6 characters password required'
                            : null,
                      ),
                    ],
                  ],
                ),
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
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final provider = context.read<SuperAdminProvider>();
                  final name = nameController.text.trim();
                  String email = emailController.text.trim().toLowerCase();
                  final password = passwordController.text.trim();

                  if (!email.contains('@')) {
                    email = '$email@admin.com';
                  }

                  if (isEditing) {
                    provider.updateCinemaAdmin(
                      adminToEdit.id,
                      adminToEdit.copyWith(name: name, email: email),
                    );
                    AppToast.showSuccess('Cinema Admin updated');
                  } else {
                    final authService = FirebaseAuthService();
                    await authService.signUpWithEmailAndPassword(
                      email: email,
                      password: password,
                      name: name,
                    );

                    provider.addCinemaAdmin(
                      CinemaAdminModel(
                        id: 'CADM-00${provider.cinemaAdmins.length + 1}',
                        name: name,
                        email: email,
                        assignedLocation: 'All Cinema Screens',
                        isActive: true,
                        createdDate: 'Today',
                      ),
                    );
                    AppToast.showSuccess(
                      'Cinema Admin ($email) created in Firebase!',
                    );
                  }

                  if (dialogCtx.mounted) {
                    Navigator.pop(dialogCtx);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.themeColor,
              ),
              child: Text(
                isEditing ? 'Save Changes' : 'Create Admin',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(color: AppColor.white),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColor.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
            filled: true,
            fillColor: AppColor.backgroundColor,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.themeColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.red),
            ),
          ),
        ),
      ],
    );
  }
}

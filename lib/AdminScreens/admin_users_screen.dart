import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/Model/user_model.dart';
import 'package:imax_movie_ticket_booking/Provider/admin_provider.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_text_style.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = context.watch<AdminProvider>();
    final users = adminProvider.filteredUsers;

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header & Summary Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Management',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'View and manage registered customers and booking history',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColor.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  ElevatedButton.icon(
                    onPressed: () => _showAddEditUserDialog(context),
                    icon: const Icon(
                      Icons.person_add_rounded,
                      color: AppColor.white,
                      size: 18,
                    ),
                    label: Text(
                      'Add User',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.themeColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
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

              /// Search Field
              TextField(
                controller: _searchController,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColor.white),
                onChanged: (val) {
                  context.read<AdminProvider>().setUserSearchQuery(val.trim());
                },
                decoration: InputDecoration(
                  hintText: 'Search user by name, email, or phone...',
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.grey,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColor.grey),
                  suffixIcon: adminProvider.userSearchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColor.grey),
                          onPressed: () {
                            _searchController.clear();
                            context.read<AdminProvider>().setUserSearchQuery(
                              '',
                            );
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

              /// Users Count Banner
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColor.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.borderColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Total Registered Customers: ${adminProvider.totalUsersCount}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Showing ${users.length} results',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// Users List / Empty State
              Expanded(
                child: users.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.people_outline,
                              size: 56,
                              color: AppColor.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No registered users found',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColor.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Try adjusting your search terms.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColor.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColor.cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColor.borderColor),
                            ),
                            child: Row(
                              children: [
                                /// Avatar Icon
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: AppColor.themeColor
                                      .withValues(alpha: 0.2),
                                  child: Text(
                                    user.name.isNotEmpty
                                        ? user.name[0].toUpperCase()
                                        : 'U',
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: AppColor.themeColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                /// User Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.titleSmall
                                            .copyWith(
                                              color: AppColor.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${user.email}  •  ${user.phone}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColor.grey,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: [
                                          Text(
                                            'Joined: ${user.registeredDate}',
                                            style: AppTextStyles.bodySmall
                                                .copyWith(
                                                  color: AppColor.textMuted,
                                                  fontSize: 10,
                                                ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColor.themeColor
                                                  .withValues(alpha: 0.15),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              '${user.bookingCount} Bookings',
                                              style: AppTextStyles.labelSmall
                                                  .copyWith(
                                                    color: AppColor.themeColor,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                /// Actions Menu / Buttons
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(6),
                                      icon: const Icon(
                                        Icons.info_outline,
                                        color: AppColor.blue,
                                        size: 18,
                                      ),
                                      onPressed: () =>
                                          _showUserDetailsModal(context, user),
                                      tooltip: 'View Details',
                                    ),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(6),
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        color: AppColor.grey,
                                        size: 18,
                                      ),
                                      onPressed: () => _showAddEditUserDialog(
                                        context,
                                        userToEdit: user,
                                      ),
                                      tooltip: 'Edit User',
                                    ),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(6),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: AppColor.red,
                                        size: 18,
                                      ),
                                      onPressed: () =>
                                          _confirmDeleteUser(context, user),
                                      tooltip: 'Delete User',
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

  void _showUserDetailsModal(BuildContext context, UserModel user) {
    final adminProvider = context.read<AdminProvider>();
    final userBookings = adminProvider.bookings
        .where(
          (b) =>
              b.customerName.toLowerCase() == user.name.toLowerCase() ||
              (user.phone.isNotEmpty && b.customerPhone == user.phone),
        )
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.8,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColor.themeColor.withValues(
                          alpha: 0.2,
                        ),
                        child: Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : 'U',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: AppColor.themeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.titleLarge.copyWith(
                                color: AppColor.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColor.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColor.borderColor),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(child: _buildInfoColumn('PHONE', user.phone)),
                      Expanded(
                        child: _buildInfoColumn(
                          'REGISTERED',
                          user.registeredDate,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoColumn(
                          'TOTAL BOOKINGS',
                          '${user.bookingCount} Tickets',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Text(
                    'Recent Activity & Bookings (${userBookings.length})',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (userBookings.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'No direct booking records found for this profile.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColor.grey,
                        ),
                      ),
                    )
                  else
                    Column(
                      children: userBookings.map((b) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColor.backgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColor.borderColor),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      b.movieTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: AppColor.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${b.date} at ${b.time} • Seats: ${b.seats.join(', ')}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColor.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'NPR ${b.totalPrice.toInt()}',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColor.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.borderColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColor.textMuted,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _confirmDeleteUser(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete User',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete user "${user.name}"?',
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
              context.read<AdminProvider>().deleteUser(user.id);
              Navigator.pop(ctx);
              AppToast.showSuccess('User record deleted');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.themeColor,
            ),
            child: Text(
              'Delete',
              style: AppTextStyles.labelMedium.copyWith(color: AppColor.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEditUserDialog(BuildContext context, {UserModel? userToEdit}) {
    final formKey = GlobalKey<FormState>();
    final isEditing = userToEdit != null;

    final nameController = TextEditingController(
      text: isEditing ? userToEdit.name : '',
    );
    final emailController = TextEditingController(
      text: isEditing ? userToEdit.email : '',
    );
    final phoneController = TextEditingController(
      text: isEditing ? userToEdit.phone : '',
    );

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColor.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isEditing ? 'Edit User Details' : 'Add New User',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 360,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFormField(
                    controller: nameController,
                    label: 'Customer Name',
                    hint: 'e.g. Susan Khatri',
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Name is required'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _buildFormField(
                    controller: emailController,
                    label: 'Email Address',
                    hint: 'susan@example.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Email is required'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _buildFormField(
                    controller: phoneController,
                    label: 'Phone Number',
                    hint: '9800000000',
                    keyboardType: TextInputType.phone,
                  ),
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
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final provider = context.read<AdminProvider>();

                if (isEditing) {
                  provider.updateUser(
                    userToEdit.id,
                    userToEdit.copyWith(
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      phone: phoneController.text.trim(),
                    ),
                  );
                  AppToast.showSuccess('User profile updated');
                } else {
                  provider.addUser(
                    UserModel(
                      id: 'USR-${provider.users.length + 101}',
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      phone: phoneController.text.trim().isEmpty
                          ? 'N/A'
                          : phoneController.text.trim(),
                      registeredDate: 'Today',
                      bookingCount: 0,
                    ),
                  );
                  AppToast.showSuccess('User created successfully');
                }

                Navigator.pop(dialogCtx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.themeColor,
            ),
            child: Text(
              isEditing ? 'Save Changes' : 'Create User',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColor.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
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
          style: AppTextStyles.bodyMedium.copyWith(color: AppColor.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
            filled: true,
            fillColor: AppColor.backgroundColor,
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

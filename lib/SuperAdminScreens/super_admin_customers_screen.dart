import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/Model/user_model.dart';
import 'package:imax_movie_ticket_booking/Provider/super_admin_provider.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_text_style.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';
import 'package:provider/provider.dart';

class SuperAdminCustomersScreen extends StatefulWidget {
  const SuperAdminCustomersScreen({super.key});

  @override
  State<SuperAdminCustomersScreen> createState() =>
      _SuperAdminCustomersScreenState();
}

class _SuperAdminCustomersScreenState extends State<SuperAdminCustomersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final superAdminProvider = context.watch<SuperAdminProvider>();
    final customers = superAdminProvider.filteredCustomers;

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header & Registered Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer Management',
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Oversee registered users, booking metrics, and account status',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColor.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Total Registered',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColor.grey,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          '${superAdminProvider.totalRegisteredCustomersCount}',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColor.themeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
                  context.read<SuperAdminProvider>().setCustomerSearchQuery(
                    val.trim(),
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search customer by name, email, or phone...',
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.grey,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColor.grey),
                  suffixIcon: superAdminProvider.customerSearchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColor.grey),
                          onPressed: () {
                            _searchController.clear();
                            context
                                .read<SuperAdminProvider>()
                                .setCustomerSearchQuery('');
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

              /// Customers List
              Expanded(
                child: customers.isEmpty
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
                              'No registered customers found',
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
                        itemCount: customers.length,
                        itemBuilder: (context, index) {
                          final customer = customers[index];
                          final isActive = superAdminProvider.isCustomerActive(
                            customer.id,
                          );

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColor.cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isActive
                                    ? AppColor.borderColor
                                    : AppColor.red.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: isActive
                                      ? AppColor.purple.withValues(alpha: 0.2)
                                      : AppColor.grey.withValues(alpha: 0.2),
                                  child: Text(
                                    customer.name.isNotEmpty
                                        ? customer.name[0].toUpperCase()
                                        : 'U',
                                    style: AppTextStyles.titleLarge.copyWith(
                                      color: isActive
                                          ? AppColor.purple
                                          : AppColor.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                              customer.name,
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
                                                  (isActive
                                                          ? AppColor.green
                                                          : AppColor.red)
                                                      .withValues(alpha: 0.2),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              isActive
                                                  ? 'ACTIVE'
                                                  : 'DEACTIVATED',
                                              style: AppTextStyles.labelSmall
                                                  .copyWith(
                                                    color: isActive
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
                                        '${customer.email}  •  ${customer.phone}',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColor.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            'Registered: ${customer.registeredDate}',
                                            style: AppTextStyles.bodySmall
                                                .copyWith(
                                                  color: AppColor.textMuted,
                                                  fontSize: 11,
                                                ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            '${customer.bookingCount} Bookings',
                                            style: AppTextStyles.labelSmall
                                                .copyWith(
                                                  color: AppColor.themeColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.info_outline,
                                        color: AppColor.blue,
                                        size: 20,
                                      ),
                                      onPressed: () => _showCustomerDetails(
                                        context,
                                        customer,
                                      ),
                                      tooltip: 'View Details & History',
                                    ),

                                    Switch(
                                      value: isActive,
                                      activeThumbColor: AppColor.green,
                                      inactiveThumbColor: AppColor.red,
                                      onChanged: (_) {
                                        context
                                            .read<SuperAdminProvider>()
                                            .toggleCustomerStatus(customer.id);
                                        AppToast.showInfo(
                                          isActive
                                              ? 'Account deactivated for ${customer.name}'
                                              : 'Account reactivated for ${customer.name}',
                                        );
                                      },
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

  void _showCustomerDetails(BuildContext context, UserModel customer) {
    final superAdminProvider = context.read<SuperAdminProvider>();
    final userBookings = superAdminProvider.allBookings
        .where(
          (b) =>
              b.customerName.toLowerCase() == customer.name.toLowerCase() ||
              (customer.phone.isNotEmpty && b.customerPhone == customer.phone),
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
                        backgroundColor: AppColor.purple.withValues(alpha: 0.2),
                        child: Text(
                          customer.name.isNotEmpty
                              ? customer.name[0].toUpperCase()
                              : 'U',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: AppColor.purple,
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
                              customer.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.titleLarge.copyWith(
                                color: AppColor.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              customer.email,
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
                      Expanded(
                        child: _buildInfoColumn('PHONE', customer.phone),
                      ),
                      Expanded(
                        child: _buildInfoColumn(
                          'REGISTERED',
                          customer.registeredDate,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoColumn(
                          'BOOKINGS',
                          '${customer.bookingCount} Times',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Text(
                    'Booking Activity History (${userBookings.length})',
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
                        'No direct ticket transactions recorded.',
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    b.movieTitle,
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${b.date} at ${b.time} • Seats: ${b.seats.join(', ')}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColor.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
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
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColor.textMuted,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

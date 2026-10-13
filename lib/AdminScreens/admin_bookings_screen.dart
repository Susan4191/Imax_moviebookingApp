import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/Model/booking_model.dart';
import 'package:imax_movie_ticket_booking/Provider/admin_provider.dart';
import 'package:imax_movie_ticket_booking/PublicScreens/ticket_detail_screen.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_text_style.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';
import 'package:provider/provider.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = context.watch<AdminProvider>();
    final bookings = adminProvider.filteredBookings;

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header & Revenue Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking Management',
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Track ticket sales, customer bookings and cancellation status',
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
                      horizontal: 12,
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
                          'Active Revenue',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColor.grey,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          'NPR ${adminProvider.totalRevenue.toInt()}',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColor.green,
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
                  context.read<AdminProvider>().setBookingSearchQuery(
                    val.trim(),
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search by Booking ID, Customer Name, or Movie...',
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.grey,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColor.grey),
                  suffixIcon: adminProvider.bookingSearchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColor.grey),
                          onPressed: () {
                            _searchController.clear();
                            context.read<AdminProvider>().setBookingSearchQuery(
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

              const SizedBox(height: 12),

              /// Status Filter Chips
              Row(
                children: ['All', 'Confirmed', 'Cancelled'].map((status) {
                  final isSelected =
                      adminProvider.bookingStatusFilter == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(status),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          context.read<AdminProvider>().setBookingStatusFilter(
                            status,
                          );
                        }
                      },
                      selectedColor: AppColor.themeColor,
                      backgroundColor: AppColor.cardColor,
                      labelStyle: AppTextStyles.labelSmall.copyWith(
                        color: isSelected ? AppColor.white : AppColor.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppColor.themeColor
                            : AppColor.borderColor,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              /// Bookings List / Empty View
              Expanded(
                child: bookings.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.confirmation_number_outlined,
                              size: 56,
                              color: AppColor.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No bookings found',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColor.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'No matching customer bookings match your filter criteria.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColor.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final booking = bookings[index];
                          final isConfirmed = booking.status == 'Confirmed';

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColor.cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColor.borderColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Top Row: Booking ID, Status Badge & Payment Method
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.surfaceColor,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            border: Border.all(
                                              color: AppColor.borderColor,
                                            ),
                                          ),
                                          child: Text(
                                            '#${booking.id}',
                                            style: AppTextStyles.labelSmall
                                                .copyWith(
                                                  color: AppColor.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                (isConfirmed
                                                        ? AppColor.green
                                                        : AppColor.red)
                                                    .withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            border: Border.all(
                                              color: isConfirmed
                                                  ? AppColor.green
                                                  : AppColor.red,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                isConfirmed
                                                    ? Icons.check_circle
                                                    : Icons.cancel,
                                                color: isConfirmed
                                                    ? AppColor.green
                                                    : AppColor.red,
                                                size: 12,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                booking.status,
                                                style: AppTextStyles.labelSmall
                                                    .copyWith(
                                                      color: isConfirmed
                                                          ? AppColor.green
                                                          : AppColor.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 11,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text(
                                      'Paid via ${booking.paymentMethod}',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColor.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                /// Details Grid: Customer & Movie
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Customer',
                                            style: AppTextStyles.bodySmall
                                                .copyWith(
                                                  color: AppColor.grey,
                                                  fontSize: 10,
                                                ),
                                          ),
                                          Text(
                                            booking.customerName,
                                            style: AppTextStyles.titleSmall
                                                .copyWith(
                                                  color: AppColor.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          if (booking.customerPhone.isNotEmpty)
                                            Text(
                                              booking.customerPhone,
                                              style: AppTextStyles.bodySmall
                                                  .copyWith(
                                                    color: AppColor.grey,
                                                    fontSize: 11,
                                                  ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Movie & Showtime',
                                            style: AppTextStyles.bodySmall
                                                .copyWith(
                                                  color: AppColor.grey,
                                                  fontSize: 10,
                                                ),
                                          ),
                                          Text(
                                            booking.movieTitle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyles.titleSmall
                                                .copyWith(
                                                  color: AppColor.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            '${booking.date} • ${booking.time}',
                                            style: AppTextStyles.bodySmall
                                                .copyWith(
                                                  color: AppColor.grey,
                                                  fontSize: 11,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Seats (${booking.seats.length})',
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: AppColor.grey,
                                                fontSize: 10,
                                              ),
                                        ),
                                        Text(
                                          booking.seats.join(', '),
                                          style: AppTextStyles.titleSmall
                                              .copyWith(
                                                color: AppColor.themeColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          'NPR ${booking.totalPrice.toInt()}',
                                          style: AppTextStyles.labelMedium
                                              .copyWith(
                                                color: AppColor.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),
                                const Divider(
                                  color: AppColor.borderColor,
                                  height: 1,
                                ),

                                /// Action Buttons Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => TicketDetailScreen(
                                              movieName: booking.movieTitle,
                                              moviePoster: '',
                                              date: booking.date,
                                              time: booking.time,
                                              selectedSeats: booking.seats,
                                              totalAmount: booking.totalPrice,
                                              ticketId: booking.id,
                                              isBoxOffice: true,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.visibility_outlined,
                                        size: 16,
                                        color: AppColor.white,
                                      ),
                                      label: Text(
                                        'View Ticket',
                                        style: AppTextStyles.labelSmall
                                            .copyWith(color: AppColor.white),
                                      ),
                                    ),

                                    Row(
                                      children: [
                                        if (isConfirmed)
                                          TextButton.icon(
                                            onPressed: () =>
                                                _updateStatusConfirm(
                                                  context,
                                                  booking,
                                                  'Cancelled',
                                                ),
                                            icon: const Icon(
                                              Icons.cancel_outlined,
                                              size: 16,
                                              color: AppColor.orange,
                                            ),
                                            label: Text(
                                              'Cancel Booking',
                                              style: AppTextStyles.labelSmall
                                                  .copyWith(
                                                    color: AppColor.orange,
                                                  ),
                                            ),
                                          )
                                        else
                                          TextButton.icon(
                                            onPressed: () =>
                                                _updateStatusConfirm(
                                                  context,
                                                  booking,
                                                  'Confirmed',
                                                ),
                                            icon: const Icon(
                                              Icons.check_circle_outline,
                                              size: 16,
                                              color: AppColor.green,
                                            ),
                                            label: Text(
                                              'Restore Booking',
                                              style: AppTextStyles.labelSmall
                                                  .copyWith(
                                                    color: AppColor.green,
                                                  ),
                                            ),
                                          ),

                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            size: 18,
                                            color: AppColor.red,
                                          ),
                                          onPressed: () =>
                                              _confirmDeleteBooking(
                                                context,
                                                booking,
                                              ),
                                          tooltip: 'Delete Record',
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

  void _updateStatusConfirm(
    BuildContext context,
    BookingModel booking,
    String targetStatus,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '$targetStatus Booking',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to change status of Booking #${booking.id} to "$targetStatus"?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColor.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Back',
              style: AppTextStyles.labelMedium.copyWith(color: AppColor.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AdminProvider>().updateBookingStatus(
                booking.id,
                targetStatus,
              );
              Navigator.pop(ctx);
              AppToast.showSuccess('Booking status updated to $targetStatus');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: targetStatus == 'Confirmed'
                  ? AppColor.green
                  : AppColor.orange,
            ),
            child: Text(
              'Confirm',
              style: AppTextStyles.labelMedium.copyWith(color: AppColor.white),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteBooking(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Booking Record',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete record #${booking.id}? This record will be permanently deleted.',
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
              context.read<AdminProvider>().deleteBooking(booking.id);
              Navigator.pop(ctx);
              AppToast.showSuccess('Booking deleted');
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
}

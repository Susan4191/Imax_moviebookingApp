import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/Provider/super_admin_provider.dart';
import 'package:imax_movie_ticket_booking/PublicScreens/ticket_detail_screen.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_text_style.dart';
import 'package:provider/provider.dart';

class SuperAdminBookingsScreen extends StatefulWidget {
  const SuperAdminBookingsScreen({super.key});

  @override
  State<SuperAdminBookingsScreen> createState() =>
      _SuperAdminBookingsScreenState();
}

class _SuperAdminBookingsScreenState extends State<SuperAdminBookingsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final superAdminProvider = context.watch<SuperAdminProvider>();
    final bookings = superAdminProvider.filteredBookings;

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header & Overall Revenue
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Global Booking Records',
                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'View and oversee ticket transactions across all cinema auditoriums',
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
                          'Platform Revenue',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColor.grey,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          'NPR ${superAdminProvider.totalTicketRevenue.toInt()}',
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
                  context.read<SuperAdminProvider>().setBookingSearchQuery(
                    val.trim(),
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search by Booking ID, Customer, or Movie...',
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.grey,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColor.grey),
                  suffixIcon: superAdminProvider.bookingSearchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColor.grey),
                          onPressed: () {
                            _searchController.clear();
                            context
                                .read<SuperAdminProvider>()
                                .setBookingSearchQuery('');
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
                      superAdminProvider.bookingStatusFilter == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(status),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          context
                              .read<SuperAdminProvider>()
                              .setBookingStatusFilter(status);
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

              /// Bookings List
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
                              'No matching bookings found',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColor.white,
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
                                          child: Text(
                                            booking.status,
                                            style: AppTextStyles.labelSmall
                                                .copyWith(
                                                  color: isConfirmed
                                                      ? AppColor.green
                                                      : AppColor.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text(
                                      'Method: ${booking.paymentMethod}',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColor.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

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
                                        'View Full Ticket',
                                        style: AppTextStyles.labelSmall
                                            .copyWith(color: AppColor.white),
                                      ),
                                    ),

                                    Text(
                                      'Recorded: ${booking.createdAt.toString().split(' ')[0]}',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColor.textMuted,
                                        fontSize: 11,
                                      ),
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
}

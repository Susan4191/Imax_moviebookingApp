import 'package:flutter/material.dart';
import '../utils/app_color.dart';
import '../utils/app_text_style.dart';

class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({
    super.key,
    required this.movieName,
    required this.moviePoster,
    required this.date,
    required this.time,
    required this.format,
    required this.screen,
    required this.selectedSeats,
    required this.ticketPrice,
    required this.serviceFee,
    required this.totalAmount,
    this.onEditTap,
  });

  final String movieName;
  final String moviePoster;
  final String date;
  final String time;
  final String format;
  final String screen;
  final List<String> selectedSeats;
  final double ticketPrice;
  final double serviceFee;
  final double totalAmount;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    final ticketCount = selectedSeats.length;
    final seatsStr = selectedSeats.isEmpty ? 'None' : selectedSeats.join(', ');
    final double ticketsTotal = ticketPrice * ticketCount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Movie details top section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Movie poster thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildPosterWidget(moviePoster),
              ),
              const SizedBox(width: 14),

              /// Info column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      movieName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// Date & Time
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          color: AppColor.red,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '$date  •  $time',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColor.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    /// Format & Screen
                    Row(
                      children: [
                        const Icon(
                          Icons.desktop_windows_outlined,
                          color: AppColor.red,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '$format  •  $screen',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColor.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    /// Seats & Ticket count
                    Row(
                      children: [
                        const Icon(
                          Icons.event_seat_rounded,
                          color: AppColor.red,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Seats $seatsStr  •  $ticketCount ${ticketCount == 1 ? "Ticket" : "Tickets"}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColor.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              /// Edit Button
              SizedBox(
                height: 32,
                child: OutlinedButton(
                  onPressed: onEditTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColor.red,
                    side: const BorderSide(color: AppColor.red, width: 1.2),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Edit',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColor.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColor.borderColor, height: 1),
          const SizedBox(height: 14),

          /// Breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tickets ($ticketCount)',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
              Text(
                'NPR ${_formatAmount(ticketsTotal)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Service Fee',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
              Text(
                'NPR ${_formatAmount(serviceFee)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(color: AppColor.borderColor, height: 1),
          const SizedBox(height: 14),

          /// Total Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'NPR ${_formatAmount(totalAmount)}',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPosterWidget(String posterPath) {
    if (posterPath.isEmpty) {
      return Container(
        width: 80,
        height: 110,
        color: AppColor.surfaceColor,
        child: const Icon(Icons.movie, color: AppColor.red, size: 40),
      );
    }

    if (posterPath.startsWith('http://') || posterPath.startsWith('https://')) {
      return Image.network(
        posterPath,
        width: 80,
        height: 110,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 80,
          height: 110,
          color: AppColor.surfaceColor,
          child: const Icon(Icons.movie, color: AppColor.red, size: 40),
        ),
      );
    }

    return Image.asset(
      posterPath,
      width: 80,
      height: 110,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 80,
        height: 110,
        color: AppColor.surfaceColor,
        child: const Icon(Icons.movie, color: AppColor.red, size: 40),
      ),
    );
  }

  static String _formatAmount(double amount) {
    final int value = amount.toInt();
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

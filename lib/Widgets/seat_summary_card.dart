import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/seat_proviede.dart';
import '../utils/app_color.dart';
import '../utils/app_text_style.dart';

class SeatSummaryCard extends StatelessWidget {
  const SeatSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final seatProvider = context.watch<SeatProvider>();
    final selectedSeats = seatProvider.selectedSeats;
    final ticketCount = selectedSeats.length;

    final String seatsText = selectedSeats.isEmpty
        ? 'None'
        : selectedSeats.join(', ');
    final String ticketsCountText = ticketCount == 1
        ? '1 Ticket'
        : '$ticketCount Tickets';

    final String formattedTotal = _formatCurrency(seatProvider.grandTotal);

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
          /// Header Row: Selected Seats & Tickets Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Seats',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
              Text(
                ticketsCountText,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          /// Selected seat numbers (e.g. E5, E6)
          Text(
            seatsText,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColor.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          const Divider(color: AppColor.borderColor, height: 1),
          const SizedBox(height: 12),

          /// Ticket Price calculation
          _SummaryRow(
            label: 'Ticket Price',
            value: ticketCount > 0
                ? 'NPR ${_formatCurrency(seatProvider.ticketPrice)} × $ticketCount'
                : 'NPR 0',
          ),
          const SizedBox(height: 8),

          /// Service Fee
          _SummaryRow(
            label: 'Service Fee',
            value: 'NPR ${_formatCurrency(seatProvider.currentServiceFee)}',
          ),
          const SizedBox(height: 12),

          const Divider(color: AppColor.borderColor, height: 1),
          const SizedBox(height: 12),

          /// Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'NPR $formattedTotal',
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

  static String _formatCurrency(double amount) {
    final int value = amount.toInt();
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColor.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColor.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

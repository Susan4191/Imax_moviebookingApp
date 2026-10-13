import 'package:flutter/material.dart';
import '../Model/seat_model.dart';
import '../utils/app_color.dart';
import '../utils/app_text_style.dart';
import 'seat_item_widget.dart';

class SeatLegendWidget extends StatelessWidget {
  const SeatLegendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _LegendItem(
          seatType: SeatType.available,
          displayText: '',
          label: 'Available',
        ),
        _LegendItem(
          seatType: SeatType.selected,
          displayText: '',
          label: 'Selected',
        ),
        _LegendItem(
          seatType: SeatType.booked,
          displayText: 'X',
          label: 'Booked',
        ),
        _LegendItem(
          seatType: SeatType.premium,
          displayText: '',
          label: 'Premium',
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.seatType,
    required this.displayText,
    required this.label,
  });

  final SeatType seatType;
  final String displayText;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SeatShapeContainer(
          seatType: seatType,
          displayText: displayText,
          size: 20,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColor.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

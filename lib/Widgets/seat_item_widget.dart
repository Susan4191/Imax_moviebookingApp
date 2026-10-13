import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';
import 'package:provider/provider.dart';
import '../Model/seat_model.dart';
import '../Provider/seat_proviede.dart';
import '../utils/app_color.dart';

class SeatItemWidget extends StatelessWidget {
  const SeatItemWidget({super.key, required this.seatNumber});

  final String seatNumber;

  @override
  Widget build(BuildContext context) {
    final seatProvider = context.watch<SeatProvider>();
    final seatType = seatProvider.getSeatType(seatNumber);
    final numberStr = seatNumber.substring(1);

    return GestureDetector(
      onTap: () {
        final message = context.read<SeatProvider>().toggleSeat(seatNumber);
        if (message != null) {
          AppToast.showError(message);
        }
      },
      child: SeatShapeContainer(
        seatType: seatType,
        displayText: seatType == SeatType.booked ? 'X' : numberStr,
      ),
    );
  }
}

class SeatShapeContainer extends StatelessWidget {
  const SeatShapeContainer({
    super.key,
    required this.seatType,
    required this.displayText,
    this.size = 25.0,
  });

  final SeatType seatType;
  final String displayText;
  final double size;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    List<BoxShadow>? shadows;

    switch (seatType) {
      case SeatType.selected:
        backgroundColor = AppColor.red;
        borderColor = AppColor.red;
        textColor = AppColor.white;
        shadows = [
          BoxShadow(
            color: AppColor.red.withValues(alpha: 0.6),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ];
        break;
      case SeatType.booked:
        backgroundColor = const Color(0xFF1E232A);
        borderColor = const Color(0xFF323842);
        textColor = AppColor.textMuted;
        shadows = null;
        break;
      case SeatType.premium:
        backgroundColor = AppColor.orange.withValues(alpha: 0.12);
        borderColor = AppColor.orange;
        textColor = AppColor.orange;
        shadows = null;
        break;
      case SeatType.available:
        backgroundColor = AppColor.cardColor;
        borderColor = const Color(0xFF383E48);
        textColor = AppColor.white;
        shadows = null;
        break;
    }

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: shadows,
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: size * 0.42,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

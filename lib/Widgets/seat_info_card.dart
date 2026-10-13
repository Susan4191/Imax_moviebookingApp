import 'package:flutter/material.dart';
import '../utils/app_color.dart';
import '../utils/app_text_style.dart';

class SeatInfoCard extends StatelessWidget {
  const SeatInfoCard({
    super.key,
    required this.movieName,
    required this.date,
    required this.time,
    this.format = 'IMAX 2D',
    this.screen = 'Screen 1',
  });

  final String movieName;
  final String date;
  final String time;
  final String format;
  final String screen;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Movie Title
          Text(
            movieName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColor.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          /// Details Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                /// Date
                const Icon(
                  Icons.calendar_today_rounded,
                  color: AppColor.red,
                  size: 15,
                ),
                const SizedBox(width: 5),
                Text(
                  date,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 14),

                /// Divider dot or pipe
                Container(height: 12, width: 1, color: AppColor.borderColor),
                const SizedBox(width: 14),

                /// Time
                const Icon(
                  Icons.access_time_rounded,
                  color: AppColor.red,
                  size: 15,
                ),
                const SizedBox(width: 5),
                Text(
                  time,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 14),

                /// Divider pipe
                Container(height: 12, width: 1, color: AppColor.borderColor),
                const SizedBox(width: 14),

                /// Format (IMAX 2D)
                Text(
                  format,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 14),

                /// Divider pipe
                Container(height: 12, width: 1, color: AppColor.borderColor),
                const SizedBox(width: 14),

                /// Screen
                const Icon(
                  Icons.desktop_windows_outlined,
                  color: AppColor.red,
                  size: 15,
                ),
                const SizedBox(width: 5),
                Text(
                  screen,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColor.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/LoginSignAccountScreen/login_screen.dart';
import 'package:imax_movie_ticket_booking/Model/show_time_model.dart';
import 'package:imax_movie_ticket_booking/Provider/show_time_provider.dart';
import 'package:imax_movie_ticket_booking/Services/firebase_app_auth.dart';
import 'package:imax_movie_ticket_booking/utils/app_toast.dart';
import 'select seat screen.dart';
import 'package:imax_movie_ticket_booking/Widgets/gesture_getector_button.dart';
import 'package:imax_movie_ticket_booking/Widgets/movie_information_card.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_text_style.dart';
import 'package:provider/provider.dart';

import '../Model/movie_model.dart';
import '../Widgets/custom_app_bar.dart';

class ShowTimeScreen extends StatefulWidget {
  const ShowTimeScreen({super.key, required this.movie});

  final MovieModel movie;
  @override
  State<ShowTimeScreen> createState() => _ShowTimeScreenState();
}

class _ShowTimeScreenState extends State<ShowTimeScreen> {
  int selectDateIndex = 0;
  int selectTimeIndex = 0;

  void _navigateToSeats(
    BuildContext context,
    String date,
    ShowTimeModel showTime,
  ) {
    final user = FirebaseAuthService().currentUser;
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SeatSelectionScreen(
            movieName: widget.movie.title,
            moviePoster: widget.movie.poster,
            date: date,
            time: showTime.time,
            format: showTime.format,
            screen: showTime.screen,
            ticketPrice: double.tryParse(showTime.price) ?? 600,
          ),
        ),
      );
    } else {
      AppToast.showInfo('Login required for booking tickets');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final showTimeProvider = context.watch<ShowTimeProvider>();
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Selected Movie Select Date and time
              MovieInformationCard(
                moviePoster: widget.movie.poster,
                movieTitle: widget.movie.title,
                movieInformation: widget.movie.information,
                rating: widget.movie.rating,
                duration: widget.movie.durations,
              ),
              const SizedBox(height: 15),

              ///Select Date
              Text(
                "Select Date",
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColor.white,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final showDate = showTimeProvider.showDates[index];
                    final isSelected = selectDateIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectDateIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(microseconds: 250),
                        width: 70,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColor.themeColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: BoxBorder.all(
                            color: isSelected
                                ? AppColor.themeColor
                                : AppColor.borderColor,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              showTimeProvider.weekDay[showDate.weekday - 1],
                              textAlign: TextAlign.center,
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColor.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              showDate.day.toString(),
                              style: AppTextStyles.headingSmall.copyWith(
                                color: AppColor.white,
                              ),
                            ),
                            Text(
                              showTimeProvider.months[showDate.month - 1],
                              style: AppTextStyles.titleMedium.copyWith(
                                color: isSelected
                                    ? AppColor.white
                                    : AppColor.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 5),
                  itemCount: showTimeProvider.showDates.length,
                ),
              ),
              const SizedBox(height: 15),

              Text(
                "Select ShowTime",
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColor.white,
                ),
              ),
              const SizedBox(height: 5),

              Expanded(
                child: SizedBox(
                  height: 200,
                  child: GridView.builder(
                    itemCount: showTimeProvider.selectDateTime.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.05,
                        ),
                    itemBuilder: (context, index) {
                      final showTime = showTimeProvider.selectDateTime[index];

                      final bool isSelected = selectTimeIndex == index;

                      return GestureDetector(
                        onTap: showTime.isAvailable
                            ? () {
                                setState(() {
                                  selectTimeIndex = index;
                                });
                              }
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(microseconds: 250),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.cardColor,
                            border: Border.all(
                              color: isSelected
                                  ? AppColor.themeColor
                                  : AppColor.borderColor,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                showTime.time,
                                style: AppTextStyles.headingSmall.copyWith(
                                  color: AppColor.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.themeColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: AppColor.themeColor,
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Text(
                                      showTime.screen,
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColor.themeColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    showTime.format,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColor.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "NPR ${showTime.price}",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColor.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                showTime.isAvailable
                                    ? 'Available'
                                    : 'Unavailable',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: showTime.isAvailable
                                      ? AppColor.green
                                      : AppColor.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetectorButton(
                onTap: () {
                  final showDate = showTimeProvider.showDates[selectDateIndex];
                  final weekDayName =
                      showTimeProvider.weekDay[showDate.weekday - 1];
                  final monthName = showTimeProvider.months[showDate.month - 1];
                  final formattedDate =
                      "$weekDayName, ${showDate.day} $monthName";

                  final selectedShowTime =
                      showTimeProvider.selectDateTime[selectTimeIndex];

                  _navigateToSeats(context, formattedDate, selectedShowTime);
                },
                gestureText: "Select Seat",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

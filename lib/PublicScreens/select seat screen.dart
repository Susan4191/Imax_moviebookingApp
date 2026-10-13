import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/seat_proviede.dart';
import '../Widgets/cinema_screen_arc.dart';
import '../Widgets/seat_info_card.dart';
import '../Widgets/seat_item_widget.dart';
import '../Widgets/seat_legend_widget.dart';
import '../Widgets/seat_summary_card.dart';
import '../utils/app_color.dart';
import '../utils/app_text_style.dart';
import '../utils/app_toast.dart';
import 'payment_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({
    super.key,
    required this.movieName,
    this.moviePoster = '',
    required this.date,
    required this.time,
    this.format = 'IMAX 2D',
    this.screen = 'Screen 1',
    this.ticketPrice = 600,
  });

  final String movieName;
  final String moviePoster;
  final String date;
  final String time;
  final String format;
  final String screen;
  final double ticketPrice;

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SeatProvider>().setMovieAndShowtime(
          movieName: widget.movieName,
          time: widget.time,
          date: widget.date,
          ticketPrice: widget.ticketPrice,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final seatProvider = context.watch<SeatProvider>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.white),
        ),
        centerTitle: true,
        title: Image.asset('assets/images/logo_logo.png', scale: 10),
        actions: [
          IconButton(
            onPressed: () {
              AppToast.showInfo('Select seats to proceed to payment');
            },
            icon: const Icon(Icons.info_outline, color: AppColor.white),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Screen Title
              Text(
                'Select Seats',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),

              /// Selected Movie Information Card
              SeatInfoCard(
                movieName: widget.movieName,
                date: widget.date,
                time: widget.time,
                format: widget.format,
                screen: widget.screen,
              ),
              const SizedBox(height: 25),

              /// Curved Cinema Screen
              const Center(child: CinemaScreenArc()),
              const SizedBox(height: 20),

              /// Seat Grid
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: seatProvider.rows.map((row) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// Left Row Label
                            SizedBox(
                              width: 22,
                              child: Text(
                                row,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColor.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            /// First 5 seats
                            ...List.generate(5, (index) {
                              final seatNumber = '$row${index + 1}';
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                child: SeatItemWidget(seatNumber: seatNumber),
                              );
                            }),

                            /// Center Aisle Gap
                            const SizedBox(width: 18),

                            /// Next 5 seats (6 to 10)
                            ...List.generate(5, (index) {
                              final seatNumber = '$row${index + 6}';
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                child: SeatItemWidget(seatNumber: seatNumber),
                              );
                            }),

                            const SizedBox(width: 8),

                            /// Right Row Label
                            SizedBox(
                              width: 22,
                              child: Text(
                                row,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColor.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              /// Seat Legend
              const SeatLegendWidget(),
              const SizedBox(height: 25),

              /// Order Summary Card
              const SeatSummaryCard(),
              const SizedBox(height: 25),

              /// Continue Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: seatProvider.selectedSeats.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentScreen(
                                movieName: widget.movieName,
                                moviePoster: widget.moviePoster,
                                date: widget.date,
                                time: widget.time,
                                format: widget.format,
                                screen: widget.screen,
                                selectedSeats: seatProvider.selectedSeats,
                                ticketPrice: seatProvider.ticketPrice,
                                totalAmount: seatProvider.grandTotal,
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.red,
                    disabledBackgroundColor: AppColor.borderColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColor.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

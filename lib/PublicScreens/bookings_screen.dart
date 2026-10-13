import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/Provider/movie_provider.dart';
import 'package:provider/provider.dart';

import '../Widgets/custom_app_bar.dart';
import '../Widgets/movie_information_card.dart';
import '../utils/app_color.dart';
import '../utils/app_text_style.dart';
import 'ticket_detail_screen.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Page title
              Text(
                'My Bookings',
                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColor.white,
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final movie = movieProvider.nowShowingMovies[index];

                    return MovieInformationCard(
                      moviePoster: movie.poster,
                      movieTitle: movie.title,
                      movieInformation: movie.information,
                      rating: "2.2",
                      duration: "2.5 hr",
                      seats: "A14",
                      buttonText: "See ticket",
                      onButtonTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TicketDetailScreen(
                              movieName: movie.title,
                              moviePoster: movie.poster,
                              date: "Fri, 17 May",
                              time: "10:30 AM",
                              format: "IMAX 3D",
                              selectedSeats: const ["A14"],
                              totalAmount: 650,
                              isBoxOffice: false,
                            ),
                          ),
                        );
                      },
                    );
                  },

                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },

                  itemCount: movieProvider.nowShowingMovies.length,
                ),
              ),

              /// Booking card
              // BookingCard(moviePoster: "", movieTitle: ""),
            ],
          ),
        ),
      ),
    );
  }
}

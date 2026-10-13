import 'dart:async';
import 'package:flutter/material.dart';
import 'package:imax_movie_ticket_booking/Provider/movie_provider.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';
import 'package:imax_movie_ticket_booking/utils/app_text_style.dart';
import 'package:provider/provider.dart';

import '../Widgets/custom_app_bar.dart';
import '../Widgets/movie_card.dart';
import '../Widgets/movie_page_view.dart';
import 'show_time_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _pageController;
  Timer? _timer;
  int currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      final movieProvider = context.read<MovieProvider>();
      final moviesCount = movieProvider.nowShowingMovies.length;
      if (moviesCount == 0) return;

      final nextIndex = (currentBannerIndex + 1) % moviesCount;

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final movie = movieProvider.nowShowingMovies;

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Featured Movies",
              style: AppTextStyles.headingSmall.copyWith(color: AppColor.white),
            ),
            const SizedBox(height: 10),

            if (movie.isEmpty)
              Container(
                height: 200,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.borderColor),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.movie_outlined,
                      size: 48,
                      color: AppColor.grey,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No Movies in Catalog',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColor.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add movies from Admin / Super Admin Panel.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              SizedBox(
                height: 250,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: movie.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentBannerIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final movieView = movie[index];

                    return MoviePageView(
                      moviePoster: movieView.poster,
                      movieName: movieView.title,
                      movieInformation: movieView.information,
                      movieRating: movieView.rating ?? "N/A",
                      movieDuration: movieView.durations ?? "N/A",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ShowTimeScreen(movie: movieView),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              /// Slide effect indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(movie.length, (index) {
                  final bool isSelected = currentBannerIndex == index;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: isSelected ? 25 : 10,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColor.themeColor : AppColor.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
            ],

            const SizedBox(height: 16),
            Text(
              movieProvider.category[0],
              style: AppTextStyles.headingSmall.copyWith(color: AppColor.white),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: movie.isEmpty
                  ? Center(
                      child: Text(
                        'No "Now Showing" movies available.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColor.grey,
                        ),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 600;
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isWide ? 4 : 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 15,
                                childAspectRatio: isWide ? 0.65 : 0.55,
                              ),
                          itemCount: movie.length,
                          itemBuilder: (context, index) {
                            final m = movie[index];

                            return MovieCard(
                              moviePoster: m.poster,
                              movieName: m.title,
                              movieInformation: m.information,
                              movieRating: m.rating ?? "N/A",
                              movieDuration: m.durations ?? "N/A",
                              buttonText: "Book Ticket",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ShowTimeScreen(movie: m),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

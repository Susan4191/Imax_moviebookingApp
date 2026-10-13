import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/movie_provider.dart';
import '../Widgets/custom_app_bar.dart';
import '../Widgets/movie_card.dart';
import '../utils/app_color.dart';
import '../utils/app_text_style.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Movies",
              style: AppTextStyles.headingMedium.copyWith(
                color: AppColor.white,
              ),
            ),
            const SizedBox(height: 15),

            /// Search field
            TextFormField(
              controller: searchController,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColor.white),
              cursorColor: AppColor.themeColor,
              decoration: InputDecoration(
                hintText: "Search Movies",
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColor.grey,
                ),
                prefixIcon: const Icon(Icons.search, color: AppColor.grey),
                fillColor: AppColor.cardColor,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColor.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColor.themeColor),
                ),
              ),
            ),
            const SizedBox(height: 15),

            /// Movies Categories
            Row(
              children: List.generate(movieProvider.category.length, (index) {
                final bool isSelected = movieProvider.selectedCategory == index;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      movieProvider.changeCategory(index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: EdgeInsets.only(
                        right: index == movieProvider.category.length - 1
                            ? 0
                            : 8,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColor.themeColor
                            : AppColor.cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColor.themeColor
                              : AppColor.borderColor,
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          movieProvider.category[index],
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isSelected ? AppColor.white : AppColor.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 15),
            Text(
              movieProvider.category[movieProvider.selectedCategory],
              style: AppTextStyles.headingSmall.copyWith(color: AppColor.white),
            ),
            const SizedBox(height: 15),

            /// Movie grid or empty result
            Expanded(
              child: movieProvider.selectedMovies.isEmpty
                  ? Center(
                      child: Text(
                        'No movies available in this category.',
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
                          itemCount: movieProvider.selectedMovies.length,
                          itemBuilder: (context, index) {
                            final movie = movieProvider.selectedMovies[index];
                            return MovieCard(
                              moviePoster: movie.poster,
                              movieName: movie.title,
                              movieInformation: movie.information,
                              movieRating: movie.rating ?? "N/A",
                              movieDuration: movie.durations ?? "N/A",
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

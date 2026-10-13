import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../utils/app_text_style.dart';

class MoviePageView extends StatelessWidget {
  const MoviePageView({
    super.key,
    required this.moviePoster,
    required this.movieName,
    required this.movieInformation,
    required this.movieRating,
    required this.movieDuration,
    this.buttonText,
    this.onTap,
  });
  final String moviePoster;
  final String movieName;
  final String movieInformation;
  final String movieRating;
  final String movieDuration;
  final String? buttonText;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// Movie image
            Image.network(
              moviePoster,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return CircularProgressIndicator(color: AppColor.themeColor);
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Icon(Icons.movie_creation_outlined));
              },
            ),

            /// Dark overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),
            Positioned(
              left: 15,
              right: 15,
              bottom: 15,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movieName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.headingSmall.copyWith(
                            color: AppColor.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          movieInformation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColor.white,
                          ),
                        ),
                        const SizedBox(width: 10),

                        Row(
                          children: [
                            const Icon(
                              Icons.timelapse,
                              color: AppColor.grey,
                              size: 15,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              movieDuration,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColor.grey,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.star,
                              color: AppColor.grey,
                              size: 15,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              movieRating,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColor.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.themeColor,
                      foregroundColor: AppColor.white,
                    ),
                    child: const Text("Book Now"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

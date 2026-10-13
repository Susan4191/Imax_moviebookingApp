import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../utils/app_text_style.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
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
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Movie poster
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Image.network(
                moviePoster,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.themeColor,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: AppColor.grey,
                      size: 45,
                    ),
                  );
                },
              ),
            ),
          ),

          /// Movie details
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movieName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColor.white,
                  ),
                ),
                const SizedBox(height: 5),

                Row(
                  children: [
                    const Icon(Icons.star, color: AppColor.grey, size: 13),
                    const SizedBox(width: 5),
                    Text(
                      movieRating,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColor.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.access_time,
                      color: AppColor.grey,
                      size: 13,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      movieDuration,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                ),
                Text(
                  movieInformation,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
                ),
                const SizedBox(height: 10),

                if (buttonText != null) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.themeColor,
                        foregroundColor: AppColor.white,
                      ),
                      child: Text(buttonText!),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

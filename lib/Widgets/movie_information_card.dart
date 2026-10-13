import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../utils/app_text_style.dart';

class MovieInformationCard extends StatelessWidget {
  const MovieInformationCard({
    super.key,
    required this.moviePoster,
    required this.movieTitle,
    required this.movieInformation,
    this.rating,
    this.duration,
    this.seats,
    this.buttonText,
    this.onButtonTap,
  });

  final String moviePoster;
  final String movieTitle;
  final String movieInformation;
  final String? rating;
  final String? duration;
  final String? seats;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Movie poster
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              moviePoster,
              width: 105,
              alignment: Alignment.center,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return Container(
                  width: 105,
                  alignment: Alignment.center,
                  color: AppColor.backgroundColor,
                  child: const CircularProgressIndicator(
                    color: AppColor.themeColor,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 105,
                  alignment: Alignment.center,
                  color: AppColor.backgroundColor,
                  child: const Icon(
                    Icons.movie_creation_outlined,
                    color: AppColor.grey,
                    size: 40,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          /// Movie information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movieTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColor.white,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  movieInformation,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    const Icon(Icons.timelapse, color: AppColor.grey, size: 15),
                    const SizedBox(width: 3),
                    Text(
                      duration ?? "",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColor.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.star, color: AppColor.grey, size: 15),
                    const SizedBox(width: 3),
                    Text(
                      rating ?? "",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    const Icon(
                      Icons.event_seat_outlined,
                      color: AppColor.grey,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      seats ?? '',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                ),

                if (buttonText != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.themeColor,
                      foregroundColor: AppColor.themeColor,
                    ),
                    onPressed: onButtonTap,
                    child: Text(
                      buttonText!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColor.white,
                      ),
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

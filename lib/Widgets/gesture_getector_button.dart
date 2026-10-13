import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../utils/app_text_style.dart';

class GestureDetectorButton extends StatelessWidget {
  const GestureDetectorButton({
    super.key,
    required this.onTap,
    this.gestureText,
  });

  final String? gestureText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.themeColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          gestureText ?? "",
          style: AppTextStyles.labelLarge.copyWith(color: AppColor.white),
        ),
      ),
    );
  }
}

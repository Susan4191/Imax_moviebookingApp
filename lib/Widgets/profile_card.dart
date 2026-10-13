import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../utils/app_text_style.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailingText,
    this.iconColor = AppColor.themeColor,
    this.titleColor = AppColor.white,
    this.borderColor = AppColor.borderColor,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final Color iconColor;
  final Color titleColor;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(color: titleColor),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
              )
            : null,
        trailing: trailingText != null
            ? Text(
                trailingText!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
              )
            : Icon(Icons.arrow_forward_ios, color: iconColor, size: 17),
      ),
    );
  }
}

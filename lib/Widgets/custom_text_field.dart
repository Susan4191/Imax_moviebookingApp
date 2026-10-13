import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../utils/app_text_style.dart';

class CostumeTextField extends StatelessWidget {
  const CostumeTextField({
    super.key,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
  });
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      controller: controller,
      style: AppTextStyles.bodyLarge.copyWith(color: AppColor.white),
      cursorColor: AppColor.themeColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.backgroundColor,
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColor.textMuted),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColor.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColor.borderColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.red),
        ),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: GestureDetector(
          onTap: onSuffixTap,
          child: Icon(suffixIcon),
        ),
      ),
    );
  }
}

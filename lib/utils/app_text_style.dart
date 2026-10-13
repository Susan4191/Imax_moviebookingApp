import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  /// Splash screens and large promotional text
  static final displayLarge = GoogleFonts.inter(
    fontSize: 40,
    fontWeight: FontWeight.w700,
  );

  static final displayMedium = GoogleFonts.inter(
    fontSize: 34,
    fontWeight: FontWeight.w700,
  );

  /// Page and section headings
  static final headingLarge = GoogleFonts.inter(
    fontSize: 30,
    fontWeight: FontWeight.w700,
  );

  static final headingMedium = GoogleFonts.inter(
    fontSize: 26,
    fontWeight: FontWeight.w700,
  );

  static final headingSmall = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  /// Movie, card and dialog titles
  static final titleLarge = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static final titleMedium = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static final titleSmall = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  /// Descriptions and general text
  static final bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static final bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static final bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  /// Buttons, inputs, chips and navigation
  static final labelLarge = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static final labelMedium = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static final labelSmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}

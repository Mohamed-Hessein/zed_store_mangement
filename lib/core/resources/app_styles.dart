import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';

class AppStyles {
  static TextStyle text32purple = GoogleFonts.plusJakartaSans(
    letterSpacing: -0.75,
    color: AppColors.primaryPurple,
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle text16grey = GoogleFonts.manrope(
    color: AppColors.textTertiary,
    fontSize: 16.sp,
  );

  static TextStyle text14grey = GoogleFonts.manrope(
    fontWeight: FontWeight.bold,
    color: AppColors.textSecondary,
    fontSize: 14.sp,
  );


  static TextStyle get text20purple => GoogleFonts.plusJakartaSans(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryPurple,
  );

  static TextStyle get text18purple => GoogleFonts.plusJakartaSans(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryPurple,
  );

  static TextStyle get text16bold => GoogleFonts.manrope(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get text14bold => GoogleFonts.manrope(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get text13bold => GoogleFonts.manrope(
    fontSize: 13.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get text12grey => GoogleFonts.manrope(
    fontSize: 12.sp,
    color: AppColors.textSecondary,
  );

  static TextStyle get text16PurpleBold => GoogleFonts.manrope(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryPurple,
  );

  static TextStyle get text14DarkBold => GoogleFonts.manrope(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get text13DarkBold => GoogleFonts.manrope(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get text13DarkMedium => GoogleFonts.manrope(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get text12DarkMedium => GoogleFonts.manrope(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static TextStyle get text14White => GoogleFonts.manrope(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );
}

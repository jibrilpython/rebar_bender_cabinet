import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:strain_guage_box/utils/const.dart';

final appTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: kAccent,
  scaffoldBackgroundColor: kBackground,
  colorScheme: const ColorScheme.light(
    primary: kAccent,
    secondary: kSecondaryText,
    surface: kPanelBg,
    onSurface: kPrimaryText,
    onPrimary: kPanelBg,
    error: kError,
    outline: kOutline,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: kBackground,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: kPrimaryText,
      letterSpacing: 0.5,
    ),
    iconTheme: const IconThemeData(color: kPrimaryText),
  ),
  textTheme: TextTheme(
    // Display — spec-sheet headers
    displayLarge: GoogleFonts.inter(
      fontSize: 32.sp,
      fontWeight: FontWeight.w700,
      color: kPrimaryText,
      letterSpacing: -0.5,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: 26.sp,
      fontWeight: FontWeight.w600,
      color: kPrimaryText,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      color: kPrimaryText,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: kPrimaryText,
      letterSpacing: 0.2,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: kPrimaryText,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: kPrimaryText,
    ),
    // Body — tabular data / spec fields
    titleLarge: GoogleFonts.inter(
      fontSize: 15.sp,
      fontWeight: FontWeight.w500,
      color: kPrimaryText,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 13.sp,
      fontWeight: FontWeight.w500,
      color: kPrimaryText,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: kSecondaryText,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: kPrimaryText,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      color: kSecondaryText,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 11.sp,
      fontWeight: FontWeight.w400,
      color: kSecondaryText,
    ),
    // Labels — stamped metal tag style
    labelLarge: GoogleFonts.inter(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: kPrimaryText,
      letterSpacing: 0.8,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 10.sp,
      fontWeight: FontWeight.w600,
      color: kSecondaryText,
      letterSpacing: 1.2,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 9.sp,
      fontWeight: FontWeight.w700,
      color: kSecondaryText,
      letterSpacing: 1.5,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kPanelBg,
    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kRadiusStandard),
      borderSide: const BorderSide(color: kOutline, width: kStrokeWeightMedium),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kRadiusStandard),
      borderSide: const BorderSide(color: kOutline, width: kStrokeWeightMedium),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kRadiusStandard),
      borderSide: const BorderSide(color: kAccent, width: 1.5),
    ),
    hintStyle: GoogleFonts.inter(
      color: kSecondaryText,
      fontSize: 13.sp,
      fontWeight: FontWeight.w300,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kAccent,
      foregroundColor: kPanelBg,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadiusStandard),
      ),
      textStyle: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 13.sp,
        letterSpacing: 0.5,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: kAccent,
      side: const BorderSide(color: kAccent, width: kStrokeWeightMedium),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadiusStandard),
      ),
    ),
  ),
  cardTheme: CardThemeData(
    color: kPanelBg,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kRadiusLarge),
      side: const BorderSide(color: kOutline, width: kStrokeWeightMedium),
    ),
    margin: EdgeInsets.zero,
  ),
  dividerTheme: const DividerThemeData(
    color: kOutline,
    thickness: kStrokeWeight,
    space: 0,
  ),
  useMaterial3: true,
);

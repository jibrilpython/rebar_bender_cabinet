import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebar_bender_cabinet/utils/const.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  App Theme — The Rebar Bender Archive
//  "Forged & Structured" — Dark Industrial Premium
// ─────────────────────────────────────────────────────────────────────────────

ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: kBackground,
  colorScheme: const ColorScheme.dark(
    primary: kAccent,
    secondary: kAccentLight,
    surface: kSurface,
    onSurface: kPrimaryText,
    onPrimary: kBackground,
    outline: kOutline,
    error: kError,
  ),

  // ── Typography ──────────────────────────────────────────────────────────────
  textTheme: TextTheme(
    // Display — large hero titles
    displayLarge: GoogleFonts.barlow(
      fontSize: 48,
      fontWeight: FontWeight.w800,
      color: kPrimaryText,
      letterSpacing: -1.0,
    ),
    displayMedium: GoogleFonts.barlow(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: kPrimaryText,
      letterSpacing: -0.5,
    ),
    displaySmall: GoogleFonts.barlow(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: kPrimaryText,
    ),

    // Headlines
    headlineLarge: GoogleFonts.barlow(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: kPrimaryText,
    ),
    headlineMedium: GoogleFonts.barlow(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: kPrimaryText,
    ),
    headlineSmall: GoogleFonts.barlow(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: kPrimaryText,
    ),

    // Titles
    titleLarge: GoogleFonts.barlow(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: kPrimaryText,
      letterSpacing: 0.2,
    ),
    titleMedium: GoogleFonts.barlow(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: kPrimaryText,
    ),
    titleSmall: GoogleFonts.barlow(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: kSecondaryText,
      letterSpacing: 0.5,
    ),

    // Body
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: kPrimaryText,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: kPrimaryText,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: kSecondaryText,
    ),

    // Labels
    labelLarge: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: kPrimaryText,
      letterSpacing: 0.5,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: kSecondaryText,
      letterSpacing: 0.8,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: kMutedText,
      letterSpacing: 1.0,
    ),
  ),

  // ── App Bar ─────────────────────────────────────────────────────────────────
  appBarTheme: AppBarTheme(
    backgroundColor: kBackground,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: GoogleFonts.barlow(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: kPrimaryText,
    ),
    iconTheme: const IconThemeData(color: kPrimaryText),
  ),

  // ── Input Decoration ────────────────────────────────────────────────────────
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kPanelBg,
    hintStyle: GoogleFonts.inter(
      fontSize: 14,
      color: kMutedText,
    ),
    labelStyle: GoogleFonts.inter(
      fontSize: 14,
      color: kSecondaryText,
    ),
    floatingLabelStyle: GoogleFonts.inter(
      fontSize: 12,
      color: kAccent,
    ),
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
      borderSide: const BorderSide(color: kAccent, width: kStrokeWeightThick),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kRadiusStandard),
      borderSide: const BorderSide(color: kError, width: kStrokeWeightMedium),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: kSpaceMD,
      vertical: kSpaceMD,
    ),
  ),

  // ── Elevated Button ─────────────────────────────────────────────────────────
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kAccent,
      foregroundColor: kBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadiusLarge),
      ),
      textStyle: GoogleFonts.barlow(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: kSpaceLG,
        vertical: kSpaceMD,
      ),
    ),
  ),

  // ── Text Button ─────────────────────────────────────────────────────────────
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: kAccent,
      textStyle: GoogleFonts.barlow(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  // ── Chip ────────────────────────────────────────────────────────────────────
  chipTheme: ChipThemeData(
    backgroundColor: kPanelBg,
    labelPadding: const EdgeInsets.symmetric(horizontal: kSpaceSM),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kRadiusPill),
      side: const BorderSide(color: kOutline, width: kStrokeWeightThin),
    ),
    labelStyle: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: kSecondaryText,
    ),
    selectedColor: kAccentMuted,
    checkmarkColor: kAccent,
  ),

  // ── Bottom Nav Bar ──────────────────────────────────────────────────────────
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: kSurface,
    selectedItemColor: kAccent,
    unselectedItemColor: kMutedText,
    showUnselectedLabels: true,
    elevation: 0,
  ),

  // ── Divider ─────────────────────────────────────────────────────────────────
  dividerTheme: const DividerThemeData(
    color: kOutline,
    thickness: 1,
  ),

  // ── Icon ────────────────────────────────────────────────────────────────────
  iconTheme: const IconThemeData(
    color: kSecondaryText,
    size: 20,
  ),
);

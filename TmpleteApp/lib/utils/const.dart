import 'package:flutter/material.dart';
import 'package:strain_guage_box/enum/my_enums.dart';

// ─── COLOR PALETTE — "The Blueprinted Archive" ──────────────────────────────
const Color kBackground = Color(0xFFE0E5EC);    // Deep neomorphic contrast base
const Color kPrimaryText = Color(0xFF0F1115);   // Deep carbon black/ink
const Color kPanelBg = Color(0xFFF2F3F5);       // Light brushed aluminum
const Color kSecondaryText = Color(0xFF545B63); // Muted slate / technical sub-notes
const Color kAccent = Color(0xFF2C4A70);        // Blueprint Blue — industrial & authoritative
const Color kOutline = Color(0xFFD1D5DB);       // Metallic silver / machined edge
const Color kError = Color(0xFFB22222);         // Critical errors / industrial warning red

// Derived
const Color kAccentLight = Color(0xFFDEE6F0);   // Faint blueprint tint
const Color kSuccess = Color(0xFF3A6B45);        // Muted signal green
const Color kBrass = Color(0xFF8B6B43);
const Color kBrassLight = Color(0xFFB08D57);
const Color kTeal = Color(0xFF1D4A53);
const Color kSmokedPaper = Color(0xFFEADDCD);
const Color kHammerDark = Color(0xFF141618);
const Color kHammerLight = Color(0xFF2C3036);

// ─── SPACING (8-point grid) ──────────────────────────────────────────────────
const double kSpacingXXS = 4.0;
const double kSpacingXS = 7.0;
const double kSpacingS = 10.0;
const double kSpacingM = 14.0;
const double kSpacingL = 18.0;
const double kSpacingXL = 24.0;
const double kSpacingXXL = 36.0;
const double kSpacingXXXL = 48.0;

const double kCardPadding = 16.0;
const double kSectionSpacing = 24.0;
const double kListSpacing = 12.0;
const double kScreenSafeZone = 16.0;

// ─── BORDER RADIUS — Sharp, chamfered-feel ───────────────────────────────────
const double kRadiusZero = 0.0;
const double kRadiusSubtle = 2.0;   // Nearly square — stamped metal label
const double kRadiusStandard = 4.0; // Crisp square corners
const double kRadiusMedium = 6.0;
const double kRadiusLarge = 8.0;
const double kRadiusXLarge = 12.0;
const double kRadiusPill = 999.0;

// ─── SHADOWS — Matte, no-gloss depth ────────────────────────────────────────
const BoxShadow kShadowLevel1 = BoxShadow(
  offset: Offset(0, 1),
  blurRadius: 3,
  color: Color.fromRGBO(15, 17, 21, 0.06),
);
const BoxShadow kShadowLevel2 = BoxShadow(
  offset: Offset(0, 2),
  blurRadius: 8,
  spreadRadius: -1,
  color: Color.fromRGBO(15, 17, 21, 0.10),
);
const BoxShadow kAccentGlow = BoxShadow(
  offset: Offset(0, 2),
  blurRadius: 8,
  color: Color.fromRGBO(44, 74, 112, 0.18),
);

// ─── RULE LINE — 0.5pt precision stroke ─────────────────────────────────────
const double kStrokeWeight = 0.5;
const double kStrokeWeightMedium = 1.0;

// ─── INSTRUMENT TYPE COLORS ──────────────────────────────────────────────────
Color getInstrumentTypeColor(InstrumentType type) {
  switch (type) {
    case InstrumentType.mechanicalTensometer:
      return const Color(0xFF5A6E7C); // steel blue-grey
    case InstrumentType.opticalTensometer:
      return const Color(0xFF4A6B5A); // muted teal green
    case InstrumentType.pneumaticExtensometer:
      return const Color(0xFF6B5A4A); // warm industrial brown
    case InstrumentType.deflectometer:
      return const Color(0xFF3D5266); // deep navy
    case InstrumentType.vibrograph:
      return const Color(0xFF5C4D6B); // muted violet
    case InstrumentType.vibratingWire:
      return const Color(0xFF4A6B66); // slate teal
    case InstrumentType.wireFoilGauge:
      return const Color(0xFF6B5E4A); // brass-tinged
    case InstrumentType.other:
      return kSecondaryText;
  }
}

// ─── CONDITION COLORS ────────────────────────────────────────────────────────
Color getConditionColor(ConditionState state) {
  switch (state) {
    case ConditionState.operational:
      return kSuccess;
    case ConditionState.requiresCalibration:
      return const Color(0xFF7B6B3A); // amber-warning
    case ConditionState.museumQuality:
      return kAccent;
    case ConditionState.forParts:
      return kError;
    case ConditionState.unknown:
      return kSecondaryText;
  }
}

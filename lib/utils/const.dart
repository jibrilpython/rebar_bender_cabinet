import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Design Tokens — The Rebar Bender Archive
//  "Forged & Structured" — Dark Industrial Premium
// ─────────────────────────────────────────────────────────────────────────────

// ── Base Palette ─────────────────────────────────────────────────────────────

/// Deep forge grey — primary background
const Color kBackground = Color(0xFF1A1A1F);

/// Slightly lighter surface for cards / panels
const Color kSurface = Color(0xFF22222A);

/// Panel / bento-box background
const Color kPanelBg = Color(0xFF2A2A34);

/// Raised element background
const Color kRaisedBg = Color(0xFF32323E);

// ── Accent Colors ─────────────────────────────────────────────────────────────

/// Molten amber — primary accent
const Color kAccent = Color(0xFFE8962E);

/// Lighter amber for hover / highlights
const Color kAccentLight = Color(0xFFF5B04A);

/// Accent with opacity for chips / tags
const Color kAccentMuted = Color(0x33E8962E);

// ── Text Colors ───────────────────────────────────────────────────────────────

/// Primary text — off-white
const Color kPrimaryText = Color(0xFFEEEEEE);

/// Secondary text — medium grey
const Color kSecondaryText = Color(0xFF9A9AAF);

/// Muted text — dim grey
const Color kMutedText = Color(0xFF5A5A72);

// ── Border / Outline ──────────────────────────────────────────────────────────

/// Default outline color
const Color kOutline = Color(0xFF3D3D50);

/// Accent outline
const Color kAccentOutline = Color(0x66E8962E);

// ── Status Colors ─────────────────────────────────────────────────────────────

const Color kSuccess = Color(0xFF4CAF50);
const Color kError = Color(0xFFE53935);
const Color kWarning = Color(0xFFFFB300);

// ── Stroke Weights ────────────────────────────────────────────────────────────

const double kStrokeWeightThin = 1.0;
const double kStrokeWeightMedium = 1.5;
const double kStrokeWeightThick = 2.5;

// ── Border Radii ──────────────────────────────────────────────────────────────

const double kRadiusSmall = 6.0;
const double kRadiusStandard = 10.0;
const double kRadiusLarge = 16.0;
const double kRadiusXLarge = 24.0;
const double kRadiusPill = 100.0;

// ── Spacing ───────────────────────────────────────────────────────────────────

const double kSpaceXS = 4.0;
const double kSpaceSM = 8.0;
const double kSpaceMD = 16.0;
const double kSpaceLG = 24.0;
const double kSpaceXL = 32.0;
const double kSpaceXXL = 48.0;

// ── Shadows ───────────────────────────────────────────────────────────────────

const List<BoxShadow> kShadowSoft = [
  BoxShadow(
    color: Color(0x40000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  ),
];

const List<BoxShadow> kShadowMedium = [
  BoxShadow(
    color: Color(0x60000000),
    blurRadius: 20,
    offset: Offset(0, 8),
  ),
];

const List<BoxShadow> kShadowAccent = [
  BoxShadow(
    color: Color(0x40E8962E),
    blurRadius: 16,
    offset: Offset(0, 4),
  ),
];

// ── Condition Colors ──────────────────────────────────────────────────────────

const Map<String, Color> kConditionColors = {
  'mint': Color(0xFF4CAF50),
  'excellent': Color(0xFF8BC34A),
  'good': Color(0xFFCDDC39),
  'fair': Color(0xFFFFB300),
  'poor': Color(0xFFFF5722),
  'restoration': Color(0xFF9E9E9E),
};

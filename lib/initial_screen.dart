import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebar_bender_cabinet/providers/user_provider.dart';
import 'package:rebar_bender_cabinet/utils/const.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Initial Screen — first-time user onboarding
//  "Forged & Structured" welcome plate
// ─────────────────────────────────────────────────────────────────────────────

class InitialScreen extends ConsumerWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top badge ──────────────────────────────────────────────────
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: kAccentMuted,
                  borderRadius: BorderRadius.circular(kRadiusPill),
                  border: Border.all(color: kAccentOutline, width: kStrokeWeightMedium),
                ),
                child: Text(
                  'COLLECTOR\'S EDITION',
                  style: GoogleFonts.barlow(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: kAccent,
                    letterSpacing: 2.0,
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // ── Hero Title ────────────────────────────────────────────────
              Text(
                'THE REBAR\nBENDER\nARCHIVE',
                style: GoogleFonts.barlow(
                  fontSize: 52.sp,
                  fontWeight: FontWeight.w900,
                  color: kPrimaryText,
                  height: 0.95,
                  letterSpacing: -2.0,
                ),
              ),

              SizedBox(height: 24.h),

              // ── Accent divider ────────────────────────────────────────────
              Container(
                width: 60.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: kAccent,
                  borderRadius: BorderRadius.circular(kRadiusPill),
                ),
              ),

              SizedBox(height: 24.h),

              // ── Subtitle ──────────────────────────────────────────────────
              Text(
                'A digital archive for collectors of\nhistorical rebar bending tools.\nDocument, catalog, and preserve\nyour collection.',
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: kSecondaryText,
                  height: 1.6,
                ),
              ),

              const Spacer(),

              // ── Feature pills ─────────────────────────────────────────────
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFeaturePill(Icons.grid_view_rounded, 'Catalog'),
                  _buildFeaturePill(Icons.photo_library_outlined, 'Photos'),
                  _buildFeaturePill(Icons.bar_chart_rounded, 'Analytics'),
                  _buildFeaturePill(Icons.search_rounded, 'Search'),
                ],
              ),

              SizedBox(height: 32.h),

              // ── Bento tech plate ──────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: kPanelBg,
                  borderRadius: BorderRadius.circular(kRadiusLarge),
                  border: Border.all(color: kOutline, width: kStrokeWeightMedium),
                  boxShadow: kShadowSoft,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: kAccentMuted,
                        borderRadius: BorderRadius.circular(kRadiusStandard),
                      ),
                      child: Icon(Icons.build_rounded, color: kAccent, size: 20.r),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rebar Bender Archive',
                            style: GoogleFonts.barlow(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryText,
                            ),
                          ),
                          Text(
                            'v1.0 — Industrial Collector App',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: kMutedText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // ── CTA Button ────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccent,
                    foregroundColor: kBackground,
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kRadiusLarge),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    ref.read(userProvider).setNotFirstTime();
                  },
                  child: Text(
                    'START YOUR ARCHIVE',
                    style: GoogleFonts.barlow(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: kBackground,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturePill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: kPanelBg,
        borderRadius: BorderRadius.circular(kRadiusPill),
        border: Border.all(color: kOutline, width: kStrokeWeightThin),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: kAccent, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: kSecondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

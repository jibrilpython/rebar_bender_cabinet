import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strain_guage_box/providers/user_provider.dart';
import 'package:strain_guage_box/utils/const.dart';
import 'package:google_fonts/google_fonts.dart';

class InitialScreen extends ConsumerWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProv = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32.h),
              _buildTechnicalPlateHeader(),
              SizedBox(height: 36.h),
              _buildHeadline(),
              SizedBox(height: 28.h),
              _buildMachinedDataSheet(),
              SizedBox(height: 36.h), // Replaced Spacer and reduced gap
              _buildFeatureRow(),
              const Spacer(),
              _buildEnterButton(context, userProv),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechnicalPlateHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: kAccent.withValues(alpha: 0.2), width: 1),
        boxShadow: const [
          BoxShadow(
              color: Color(0xFFA3B1C6), offset: Offset(2, 2), blurRadius: 4),
          BoxShadow(
              color: Color(0xFFFFFFFF), offset: Offset(-2, -2), blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildScrewIcon(),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID: AX-8802',
                  style: GoogleFonts.firaCode(
                    color: kAccent.withValues(alpha: 0.5),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 24.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: kAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: Text(
              'PROTOTYPE',
              style: GoogleFonts.firaCode(
                color: kAccent,
                fontSize: 8.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 12.w, height: 2.h, color: kAccent),
            SizedBox(width: 8.w),
            Text(
              'OFFICIAL ARCHIVE',
              style: GoogleFonts.specialElite(
                color: kSecondaryText,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          'Strain\nGauge Box',
          style: GoogleFonts.inter(
            color: kPrimaryText,
            fontSize: 40.sp,
            fontWeight: FontWeight.w900,
            height: 0.9,
            letterSpacing: -1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildMachinedDataSheet() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: const [
          BoxShadow(
              color: Color(0xFFA3B1C6), offset: Offset(4, 4), blurRadius: 10),
          BoxShadow(
              color: Color(0xFFFFFFFF), offset: Offset(-4, -4), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          _buildSheetHeader(),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                _buildDataRow('FID', 'SGB-AR-001'),
                _buildDataRow('TYPE', 'Mechanical Cataloguer'),
                _buildDataRow('UNITS', 'Tensometers · Extensometers'),
                _buildDataRow('SENS', '0.001mm Digital Precision'),
                _buildDataRow('CLASS', 'Industrial Archive v1'),
              ],
            ),
          ),
          _buildSheetFooter(),
        ],
      ),
    );
  }

  Widget _buildSheetHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: kAccent.withValues(alpha: 0.05),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r)),
        border:
            Border(bottom: BorderSide(color: kAccent.withValues(alpha: 0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('SPECIFICATION SHEET',
              style: GoogleFonts.firaCode(
                  color: kAccent, fontSize: 8.sp, fontWeight: FontWeight.w800)),
          Text('REF: 12.0004.X',
              style: GoogleFonts.firaCode(
                  color: kAccent.withValues(alpha: 0.4), fontSize: 8.sp)),
        ],
      ),
    );
  }

  Widget _buildSheetFooter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: kAccent.withValues(alpha: 0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.qr_code_2_rounded,
              size: 14.sp, color: kAccent.withValues(alpha: 0.2)),
          SizedBox(width: 8.w),
          Text('LINK ESTABLISHED',
              style: GoogleFonts.firaCode(
                  color: kAccent.withValues(alpha: 0.3),
                  fontSize: 7.sp,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          SizedBox(
            width: 48.w,
            child: Text(label,
                style: GoogleFonts.firaCode(
                    color: kSecondaryText.withValues(alpha: 0.5),
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w800)),
          ),
          Expanded(
            child: Text(value,
                style: GoogleFonts.firaCode(
                    color: kPrimaryText,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _buildFeatureTag(Icons.inventory_2_outlined),
        _buildFeatureTag(Icons.science_outlined),
        _buildFeatureTag(Icons.photo_camera_outlined),
      ],
    );
  }

  Widget _buildFeatureTag(IconData icon) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: kBackground,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
              color: Color(0xFFA3B1C6), offset: Offset(2, 2), blurRadius: 4),
          BoxShadow(
              color: Color(0xFFFFFFFF), offset: Offset(-2, -2), blurRadius: 4),
        ],
      ),
      child: Icon(icon, size: 16.sp, color: kAccent),
    );
  }

  Widget _buildEnterButton(BuildContext context, UserNotifier userProv) {
    return GestureDetector(
      onTap: () {
        userProv.setFirstTimeUser(false);
        Navigator.pushReplacementNamed(context, '/home');
      },
      child: Container(
        width: double.infinity,
        height: 54.h,
        decoration: BoxDecoration(
          color: kAccent,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
                color: kAccent.withValues(alpha: 0.4),
                offset: const Offset(0, 8),
                blurRadius: 16),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'INITIALIZE CONNECTION',
              style: GoogleFonts.firaCode(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0),
            ),
            SizedBox(width: 12.w),
            const Icon(Icons.power_settings_new_rounded,
                color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildScrewIcon() {
    return Container(
      width: 14.w,
      height: 14.w,
      decoration: const BoxDecoration(
          color: kBackground,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Color(0xFFA3B1C6), offset: Offset(1, 1), blurRadius: 1),
            BoxShadow(
                color: Color(0xFFFFFFFF),
                offset: Offset(-1, -1),
                blurRadius: 1),
          ]),
      child: Center(
        child: Container(
            width: 10.w,
            height: 1.h,
            color: kSecondaryText.withValues(alpha: 0.3),
            transform: Matrix4.rotationZ(0.78)),
      ),
    );
  }
}

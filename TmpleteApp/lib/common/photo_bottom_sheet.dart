import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:strain_guage_box/providers/image_provider.dart';
import 'package:strain_guage_box/utils/const.dart';
import 'package:google_fonts/google_fonts.dart';

void photoBottomSheet(
  BuildContext context,
  ImageNotifier imageProv,
  int index,
  WidgetRef ref,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 32.h),
      decoration: BoxDecoration(
        color: kPanelBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(kRadiusXLarge)),
        border: Border.all(color: kOutline, width: kStrokeWeightMedium),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: kOutline,
                borderRadius: BorderRadius.circular(kRadiusPill),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // Section label
          Row(
            children: [
              Container(width: 3.w, height: 12.h, color: kAccent),
              SizedBox(width: 8.w),
              Text(
                'ADD PHOTOGRAPH',
                style: GoogleFonts.inter(
                  color: kAccent,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Camera option
          _buildPhotoOption(
            ctx,
            imageProv,
            icon: Icons.camera_alt_outlined,
            label: 'TAKE PHOTOGRAPH',
            sublabel: 'Use camera to capture specimen',
            source: ImageSource.camera,
          ),
          SizedBox(height: 8.h),
          // Gallery option
          _buildPhotoOption(
            ctx,
            imageProv,
            icon: Icons.photo_library_outlined,
            label: 'SELECT FROM GALLERY',
            sublabel: 'Choose an existing photograph',
            source: ImageSource.gallery,
          ),
        ],
      ),
    ),
  );
}

Widget _buildPhotoOption(
  BuildContext ctx,
  ImageNotifier imageProv, {
  required IconData icon,
  required String label,
  required String sublabel,
  required ImageSource source,
}) {
  return GestureDetector(
    onTap: () async {
      Navigator.pop(ctx);
      await imageProv.pickImage(source: source);
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E9ED),
        borderRadius: BorderRadius.circular(kRadiusLarge),
        border: Border.all(color: kOutline, width: kStrokeWeightMedium),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: kPanelBg,
              borderRadius: BorderRadius.circular(kRadiusStandard),
              border: Border.all(color: kOutline, width: kStrokeWeightMedium),
            ),
            child: Icon(icon, color: kAccent, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: kPrimaryText,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                sublabel,
                style: GoogleFonts.inter(
                  color: kSecondaryText,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, color: kSecondaryText, size: 14.sp),
        ],
      ),
    ),
  );
}

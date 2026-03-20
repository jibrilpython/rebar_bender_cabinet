import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rebar_bender_cabinet/providers/image_provider.dart';
import 'package:rebar_bender_cabinet/utils/const.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Photo Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

void showPhotoBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _PhotoBottomSheet(ref: ref),
  );
}

class _PhotoBottomSheet extends StatelessWidget {
  final WidgetRef ref;
  const _PhotoBottomSheet({required this.ref});

  @override
  Widget build(BuildContext context) {
    final hasImage = ref.read(imageProvider).resultImage != null;
    return Container(
      margin: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: kPanelBg,
        borderRadius: BorderRadius.circular(kRadiusXLarge),
        border: Border.all(color: kOutline, width: kStrokeWeightMedium),
        boxShadow: kShadowMedium,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w, height: 4.h,
            decoration: BoxDecoration(
              color: kOutline,
              borderRadius: BorderRadius.circular(kRadiusPill),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('ADD PHOTO', style: GoogleFonts.barlow(
                fontSize: 11.sp, fontWeight: FontWeight.w800,
                color: kAccent, letterSpacing: 2.0,
              )),
            ),
          ),
          SizedBox(height: 8.h),
          _option(context, Icons.camera_alt_outlined, 'Take Photo', 'Use your camera', () async {
            Navigator.pop(context);
            await ref.read(imageProvider).pickImage(ImageSource.camera);
          }),
          Divider(color: kOutline, thickness: 1, indent: 20.w, endIndent: 20.w),
          _option(context, Icons.photo_library_outlined, 'Choose from Gallery', 'Browse your photos', () async {
            Navigator.pop(context);
            await ref.read(imageProvider).pickImage(ImageSource.gallery);
          }),
          if (hasImage) ...[
            Divider(color: kOutline, thickness: 1, indent: 20.w, endIndent: 20.w),
            _option(context, Icons.delete_outline_rounded, 'Remove Photo', 'Clear current image', () {
              Navigator.pop(context);
              ref.read(imageProvider).clearImage();
            }, isDestructive: true),
          ],
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _option(BuildContext ctx, IconData icon, String label, String sub, VoidCallback onTap, {bool isDestructive = false}) {
    final col = isDestructive ? kError : kPrimaryText;
    final ic = isDestructive ? kError : kAccent;
    final bg = isDestructive ? kError.withAlpha(25) : kAccentMuted;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        child: Row(children: [
          Container(
            width: 44.r, height: 44.r,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(kRadiusStandard)),
            child: Icon(icon, color: ic, size: 20.r),
          ),
          SizedBox(width: 16.w),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: GoogleFonts.barlow(fontSize: 14.sp, fontWeight: FontWeight.w600, color: col)),
            Text(sub, style: GoogleFonts.inter(fontSize: 12.sp, color: kSecondaryText)),
          ]),
        ]),
      ),
    );
  }
}

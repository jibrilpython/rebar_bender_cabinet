import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strain_guage_box/models/strain_gauge_model.dart';
import 'package:strain_guage_box/providers/image_provider.dart';
import 'package:strain_guage_box/providers/project_provider.dart';
import 'package:strain_guage_box/utils/const.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoScreen extends ConsumerStatefulWidget {
  final int index;
  const InfoScreen({super.key, required this.index});

  @override
  ConsumerState<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends ConsumerState<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    final projectProv = ref.watch(projectProvider);
    if (widget.index < 0 || widget.index >= projectProv.entries.length) {
      return const Scaffold(body: Center(child: Text('INSTRUMENT NOT FOUND')));
    }
    final entry = projectProv.entries[widget.index];
    final imageProv = ref.watch(imageProvider);
    final imagePath = imageProv.getImagePath(entry.photoPath);

    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            slivers: [
              SliverAppBar(
                expandedHeight: 340.h,
                stretch: true,
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: false,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  background: _buildDynamicHeader(imagePath, entry),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 140.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildIdentityBlock(entry),
                    SizedBox(height: 24.h),
                    _buildNeomorphicSpecContainer(entry),
                    SizedBox(height: 18.h),
                    if (entry.provenance.isNotEmpty ||
                        entry.accessories.isNotEmpty ||
                        entry.notes.isNotEmpty)
                      _buildNeomorphicTextBoxes(entry),
                    if (entry.tags.isNotEmpty) ...[
                      SizedBox(height: 18.h),
                      _buildTagsSection(entry),
                    ],
                  ]),
                ),
              ),
            ],
          ),

          // Custom Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            left: 20.w,
            child: _buildNeomorphicCircleBtn(
              icon: Icons.arrow_back_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ),

          // Custom Action Buttons (Edit / Delete)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            right: 20.w,
            child: Row(
              children: [
                _buildNeomorphicCircleBtn(
                  icon: Icons.edit_rounded,
                  onTap: () {
                    projectProv.fillInput(ref, widget.index);
                    Navigator.pushNamed(context, '/add_screen', arguments: {
                      'isEdit': true,
                      'currentIndex': widget.index
                    });
                  },
                ),
                SizedBox(width: 12.w),
                _buildNeomorphicCircleBtn(
                  icon: Icons.delete_rounded,
                  iconColor: kError,
                  onTap: () =>
                      _showDeleteDialog(context, projectProv, widget.index),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicHeader(String? imagePath, StrainGaugeModel entry) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFA3B1C6),
            // color: Colors.white,
            offset: Offset(0, 10),
            blurRadius: 20,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        child: (entry.photoPath.isNotEmpty &&
                imagePath != null &&
                File(imagePath).existsSync())
            ? Image.file(File(imagePath), fit: BoxFit.cover)
            : Container(
                color: getInstrumentTypeColor(entry.instrumentType)
                    .withValues(alpha: 0.1),
                child: Center(
                  child: Icon(
                    Icons.precision_manufacturing_rounded,
                    size: 80.sp,
                    color: getInstrumentTypeColor(entry.instrumentType)
                        .withValues(alpha: 0.3),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildIdentityBlock(StrainGaugeModel entry) {
    final conditionColor = getConditionColor(entry.conditionState);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (entry.testIdentifier.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: kBackground,
              borderRadius: BorderRadius.circular(kRadiusPill),
              boxShadow: const [
                BoxShadow(
                    color: Color(0xFFFFFFFF),
                    offset: Offset(-3, -3),
                    blurRadius: 6),
                BoxShadow(
                    color: Color(0xFFA3B1C6),
                    offset: Offset(3, 3),
                    blurRadius: 6),
              ],
            ),
            child: Text(
              entry.testIdentifier,
              style: GoogleFonts.inter(
                color: kAccent,
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
              ),
            ),
          ),
        Text(
          entry.instrumentName,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: kPrimaryText,
            fontSize: 26.sp,
            fontWeight: FontWeight.w800,
            height: 1.1,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          entry.manufacturer +
              (entry.model.isNotEmpty ? ' • ${entry.model}' : ''),
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: kSecondaryText,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 18.h),

        // Status Row Wrap (Solves overflow for long badging)
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            _buildStatusPill(
                conditionColor, entry.conditionState.label.toUpperCase()),
            _buildStatusPill(
              getInstrumentTypeColor(entry.instrumentType),
              entry.instrumentType.label.toUpperCase(),
            ),
            if (entry.hasCalibrationCert)
              _buildStatusPill(kSuccess, 'CALIBRATED', icon: Icons.verified),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusPill(Color color, String label, {IconData? icon}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(kRadiusPill),
        boxShadow: const [
          BoxShadow(
              color: Color(0xFFFFFFFF), offset: Offset(-2, -2), blurRadius: 4),
          BoxShadow(
              color: Color(0xFFA3B1C6), offset: Offset(2, 2), blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon ?? Icons.circle, size: 10.sp, color: color),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeomorphicSpecContainer(StrainGaugeModel entry) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
              color: Color(0xFFFFFFFF), offset: Offset(-8, -8), blurRadius: 16),
          BoxShadow(
              color: Color(0xFFA3B1C6), offset: Offset(8, 8), blurRadius: 16),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildInsetSpec('YEAR', '${entry.yearOfManufacture}')),
              SizedBox(width: 16.w),
              Expanded(
                  child:
                      _buildInsetSpec('COUNTRY', entry.countryOfManufacture)),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(child: _buildInsetSpec('RANGE', entry.measurementRange)),
              SizedBox(width: 16.w),
              Expanded(
                  child: _buildInsetSpec(
                      'SENSITIVITY', entry.sensitivityAccuracy)),
            ],
          ),
          SizedBox(height: 12.h),
          _buildInsetLongSpec('PRINCIPLE', entry.operatingPrinciple.label),
          if (entry.materials.isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildInsetLongSpec('MATERIALS', entry.materials),
          ]
        ],
      ),
    );
  }

  Widget _buildInsetSpec(String label, String value) {
    if (value.isEmpty) value = '—';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: const [
          BoxShadow(
              color: Color(0xFFA3B1C6), offset: Offset(2, 2), blurRadius: 6),
          BoxShadow(
              color: Color(0xFFFFFFFF), offset: Offset(-2, -2), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  color: kAccent,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5)),
          SizedBox(height: 4.h),
          Text(value,
              style: GoogleFonts.inter(
                  color: kPrimaryText,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildInsetLongSpec(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: const [
          BoxShadow(
              color: Color(0xFFA3B1C6), offset: Offset(2, 2), blurRadius: 6),
          BoxShadow(
              color: Color(0xFFFFFFFF), offset: Offset(-2, -2), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  color: kAccent,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5)),
          SizedBox(height: 4.h),
          Text(value,
              style: GoogleFonts.inter(
                  color: kPrimaryText,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildNeomorphicTextBoxes(StrainGaugeModel entry) {
    return Column(
      children: [
        if (entry.provenance.isNotEmpty)
          _buildTextBox('PROVENANCE', entry.provenance),
        if (entry.accessories.isNotEmpty)
          _buildTextBox('ACCESSORIES', entry.accessories),
        if (entry.notes.isNotEmpty) _buildTextBox('FIELD NOTES', entry.notes),
      ],
    );
  }

  Widget _buildTextBox(String label, String text) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
              color: Color(0xFFFFFFFF), offset: Offset(-6, -6), blurRadius: 12),
          BoxShadow(
              color: Color(0xFFA3B1C6), offset: Offset(6, 6), blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 12, color: kAccent),
              SizedBox(width: 8.w),
              Text(label,
                  style: GoogleFonts.inter(
                      color: kAccent,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0)),
            ],
          ),
          SizedBox(height: 12.h),
          Text(text,
              style: GoogleFonts.inter(
                  color: kSecondaryText, fontSize: 14.sp, height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildTagsSection(StrainGaugeModel entry) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: entry.tags
          .map((tag) => Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: kBackground,
                  borderRadius: BorderRadius.circular(kRadiusPill),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0xFFFFFFFF),
                        offset: Offset(-2, -2),
                        blurRadius: 4),
                    BoxShadow(
                        color: Color(0xFFA3B1C6),
                        offset: Offset(2, 2),
                        blurRadius: 4),
                  ],
                ),
                child: Text(
                  '#$tag',
                  style: GoogleFonts.inter(
                    color: kSecondaryText,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildNeomorphicCircleBtn(
      {required IconData icon,
      required VoidCallback onTap,
      Color iconColor = kAccent}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46.w,
        height: 46.w,
        decoration: const BoxDecoration(
          color: kBackground,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Color(0xFFFFFFFF),
                offset: Offset(-4, -4),
                blurRadius: 8),
            BoxShadow(
                color: Color(0xFFA3B1C6), offset: Offset(4, 4), blurRadius: 8),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 22.sp),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, ProjectNotifier projectProv, int index) {
    showDialog(
      context: context,
      builder: (ctx) => _DecommissionDialog(
        onConfirm: () {
          projectProv.deleteEntry(index);
          Navigator.pop(ctx);
          Navigator.pop(context);
        },
        onCancel: () => Navigator.pop(ctx),
      ),
    );
  }
}

// ── DECOMMISSION DIALOG ──────────────────────────────────────────────────────
class _DecommissionDialog extends StatefulWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _DecommissionDialog({required this.onConfirm, required this.onCancel});

  @override
  State<_DecommissionDialog> createState() => _DecommissionDialogState();
}

class _DecommissionDialogState extends State<_DecommissionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 24.w),
        decoration: BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
                color: Color(0xFFFFFFFF),
                offset: Offset(-10, -10),
                blurRadius: 20),
            BoxShadow(
                color: Color(0xFFA3B1C6),
                offset: Offset(10, 10),
                blurRadius: 20),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: _controller.value * 2 * math.pi,
                      child: Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: kError.withValues(alpha: 0.1),
                                blurRadius: 10)
                          ],
                          border: Border.all(
                              color: kError.withValues(alpha: 0.3), width: 1.5),
                        ),
                      ),
                    ),
                    Icon(Icons.warning_amber_rounded,
                        color: kError, size: 36.sp),
                  ],
                );
              },
            ),
            SizedBox(height: 24.h),
            Text(
              'DELETE RECORD?',
              style: GoogleFonts.inter(
                color: kError,
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'This instrument will be permanently removed from your archive. This action cannot be undone.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  color: kSecondaryText, fontSize: 13.sp, height: 1.5),
            ),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onCancel,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: kBackground,
                        borderRadius: BorderRadius.circular(kRadiusPill),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0xFFFFFFFF),
                              offset: Offset(-3, -3),
                              blurRadius: 6),
                          BoxShadow(
                              color: Color(0xFFA3B1C6),
                              offset: Offset(3, 3),
                              blurRadius: 6),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'CANCEL',
                          style: GoogleFonts.inter(
                              color: kSecondaryText,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onConfirm,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: kBackground,
                        borderRadius: BorderRadius.circular(kRadiusPill),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0xFFA3B1C6),
                              offset: Offset(3, 3),
                              blurRadius: 6),
                          BoxShadow(
                              color: Color(0xFFFFFFFF),
                              offset: Offset(-3, -3),
                              blurRadius: 6),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'DELETE',
                          style: GoogleFonts.inter(
                              color: kError, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebar_bender_cabinet/models/rebar_tool_model.dart';
import 'package:rebar_bender_cabinet/providers/project_provider.dart';
import 'package:rebar_bender_cabinet/screens/add_screen.dart';
import 'package:rebar_bender_cabinet/utils/const.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Info Screen — detailed view for a single tool
// ─────────────────────────────────────────────────────────────────────────────

class InfoScreen extends ConsumerWidget {
  final RebarToolModel item;
  const InfoScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conditionColor = kConditionColors[item.conditionState?.name] ?? kSecondaryText;

    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        slivers: [
          // ── Hero App Bar ────────────────────────────────────────────────────
          SliverAppBar(
            backgroundColor: kBackground,
            expandedHeight: 280.h,
            pinned: true,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: EdgeInsets.all(8.r),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: kBackground.withAlpha(200),
                    borderRadius: BorderRadius.circular(kRadiusStandard),
                    border: Border.all(color: kOutline),
                  ),
                  child: Icon(Icons.arrow_back_rounded, color: kPrimaryText, size: 20.r),
                ),
              ),
            ),
            actions: [
              // Edit
              Padding(
                padding: EdgeInsets.only(right: 4.r),
                child: GestureDetector(
                  onTap: () {
                    ref.read(projectProvider).loadItemIntoInput(item, ref);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => const AddScreen(isEdit: true),
                    ));
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.r),
                    width: 36.r, height: 36.r,
                    decoration: BoxDecoration(
                      color: kBackground.withAlpha(200),
                      borderRadius: BorderRadius.circular(kRadiusStandard),
                      border: Border.all(color: kOutline),
                    ),
                    child: Icon(Icons.edit_outlined, color: kAccent, size: 18.r),
                  ),
                ),
              ),
              // Delete
              Padding(
                padding: EdgeInsets.only(right: 8.r),
                child: GestureDetector(
                  onTap: () => _confirmDelete(context, ref),
                  child: Container(
                    margin: EdgeInsets.all(8.r),
                    width: 36.r, height: 36.r,
                    decoration: BoxDecoration(
                      color: kBackground.withAlpha(200),
                      borderRadius: BorderRadius.circular(kRadiusStandard),
                      border: Border.all(color: kOutline),
                    ),
                    child: Icon(Icons.delete_outline_rounded, color: kError, size: 18.r),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: item.imagePath != null
                  ? Image.file(File(item.imagePath!), fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _heroPlaceholder())
                  : _heroPlaceholder(),
            ),
          ),

          // ── Content ─────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Title row
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      if (item.catalogueIdentifier != null)
                        Text(item.catalogueIdentifier!, style: GoogleFonts.barlow(
                          fontSize: 11.sp, fontWeight: FontWeight.w700,
                          color: kAccent, letterSpacing: 2.0,
                        )),
                      SizedBox(height: 4.h),
                      Text(item.toolName ?? 'Unknown Tool', style: GoogleFonts.barlow(
                        fontSize: 24.sp, fontWeight: FontWeight.w800,
                        color: kPrimaryText, height: 1.1,
                      )),
                      if (item.manufacturer != null)
                        Text(item.manufacturer!, style: GoogleFonts.inter(
                          fontSize: 14.sp, color: kSecondaryText,
                        )),
                    ]),
                  ),
                  SizedBox(width: 12.w),
                  // Condition badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: conditionColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(kRadiusPill),
                      border: Border.all(color: conditionColor, width: kStrokeWeightThin),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 8.r, height: 8.r,
                          decoration: BoxDecoration(color: conditionColor, shape: BoxShape.circle)),
                      SizedBox(width: 6.w),
                      Text(item.conditionState?.displayName ?? 'Unknown', style: GoogleFonts.inter(
                        fontSize: 12.sp, fontWeight: FontWeight.w600, color: conditionColor,
                      )),
                    ]),
                  ),
                ]),

                SizedBox(height: 20.h),

                // Quick chips row
                Wrap(spacing: 8, runSpacing: 8, children: [
                  if (item.toolType != null) _chip(Icons.build_outlined, item.toolType!.displayName),
                  if (item.operationMethod != null) _chip(Icons.settings_outlined, item.operationMethod!.displayName),
                  if (item.eraOfProduction != null) _chip(Icons.history_rounded, item.eraOfProduction!),
                  if (item.countryOfOrigin != null) _chip(Icons.flag_outlined, item.countryOfOrigin!),
                ]),

                SizedBox(height: 24.h),

                // ── Sections ─────────────────────────────────────────────────
                if (_hasProvenance()) ...[
                  _sectionHeader('PROVENANCE'),
                  SizedBox(height: 12.h),
                  _infoPanel([
                    if (item.manufacturer != null) _row('Manufacturer', item.manufacturer!),
                    if (item.countryOfOrigin != null) _row('Country', item.countryOfOrigin!),
                    if (item.eraOfProduction != null) _row('Era', item.eraOfProduction!),
                    if (item.modelNumber != null) _row('Model No.', item.modelNumber!),
                    if (item.serialNumber != null) _row('Serial No.', item.serialNumber!),
                  ]),
                  SizedBox(height: 20.h),
                ],

                if (_hasSpecs()) ...[
                  _sectionHeader('TECHNICAL SPECS'),
                  SizedBox(height: 12.h),
                  _infoPanel([
                    if (item.rebarSizeCapacity != null) _row('Rebar Capacity', item.rebarSizeCapacity!),
                    if (item.bendAngleRange != null) _row('Bend Range', item.bendAngleRange!),
                    if (item.material != null) _row('Material', item.material!),
                    if (item.weight != null) _row('Weight', item.weight!),
                  ]),
                  SizedBox(height: 20.h),
                ],

                if (item.provenance != null || item.notes != null || item.tags != null) ...[
                  _sectionHeader('NOTES'),
                  SizedBox(height: 12.h),
                  _infoPanel([
                    if (item.provenance != null) _row('Acquisition', item.provenance!),
                    if (item.notes != null) _row('Notes', item.notes!),
                    if (item.tags != null) _row('Tags', item.tags!),
                  ]),
                  SizedBox(height: 20.h),
                ],

                SizedBox(height: 40.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasProvenance() =>
      item.manufacturer != null || item.countryOfOrigin != null ||
      item.eraOfProduction != null || item.modelNumber != null || item.serialNumber != null;

  bool _hasSpecs() =>
      item.rebarSizeCapacity != null || item.bendAngleRange != null ||
      item.material != null || item.weight != null;

  Widget _heroPlaceholder() {
    return Container(
      color: kPanelBg,
      child: Center(child: Icon(Icons.build_circle_outlined, color: kMutedText, size: 64)),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: kPanelBg,
        borderRadius: BorderRadius.circular(kRadiusPill),
        border: Border.all(color: kOutline, width: kStrokeWeightThin),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: kAccent),
        const SizedBox(width: 5),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: kSecondaryText, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _sectionHeader(String label) {
    return Row(children: [
      Container(width: 3, height: 14,
          decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(kRadiusPill))),
      const SizedBox(width: 8),
      Text(label, style: GoogleFonts.barlow(
        fontSize: 10, fontWeight: FontWeight.w800, color: kAccent, letterSpacing: 2.0,
      )),
    ]);
  }

  Widget _infoPanel(List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: kPanelBg,
        borderRadius: BorderRadius.circular(kRadiusLarge),
        border: Border.all(color: kOutline, width: kStrokeWeightThin),
      ),
      child: Column(children: rows),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          width: 110,
          child: Text(label, style: GoogleFonts.inter(
            fontSize: 12, color: kMutedText, fontWeight: FontWeight.w500,
          )),
        ),
        Expanded(child: Text(value, style: GoogleFonts.inter(
          fontSize: 13, color: kPrimaryText, fontWeight: FontWeight.w400,
        ))),
      ]),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kPanelBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusLarge),
          side: const BorderSide(color: kOutline),
        ),
        title: Text('Delete Tool?', style: GoogleFonts.barlow(
          color: kPrimaryText, fontWeight: FontWeight.w700, fontSize: 18,
        )),
        content: Text('This action cannot be undone.', style: GoogleFonts.inter(
          color: kSecondaryText, fontSize: 14,
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL', style: GoogleFonts.barlow(color: kSecondaryText, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(projectProvider).deleteItem(item.id!);
              if (context.mounted) {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back to home
              }
            },
            child: Text('DELETE', style: GoogleFonts.barlow(color: kError, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

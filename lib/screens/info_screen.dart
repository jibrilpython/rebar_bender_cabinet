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
    // Watch the project provider to get the latest state of this item
    final project = ref.watch(projectProvider);
    final currentItem = project.allItems.firstWhere(
      (e) => e.id == item.id,
      orElse: () => item,
    );

    final conditionColor =
        kConditionColors[currentItem.conditionState?.name] ?? kSecondaryText;

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
            leading: Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: kBackground.withAlpha(200),
                    borderRadius: BorderRadius.circular(kRadiusStandard),
                    border: Border.all(color: kOutline),
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: kPrimaryText,
                    size: 19.r,
                  ),
                ),
              ),
            ),

            actions: [
              // Edit
              Padding(
                padding: EdgeInsets.only(right: 4.r),
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(projectProvider)
                        .loadItemIntoInput(currentItem, ref);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddScreen(isEdit: true),
                      ),
                    );
                  },
                  child: Container(
                    width: 42.r,
                    height: 42.r,
                    decoration: BoxDecoration(
                      color: kBackground.withAlpha(200),
                      borderRadius: BorderRadius.circular(kRadiusStandard),
                      border: Border.all(color: kOutline),
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      color: kAccent,
                      size: 19.r,
                    ),
                  ),
                ),
              ),
              // Delete
              Padding(
                padding: EdgeInsets.only(right: 8.r),
                child: GestureDetector(
                  onTap: () => _confirmDelete(context, ref, currentItem),
                  child: Container(
                    width: 42.r,
                    height: 42.r,
                    decoration: BoxDecoration(
                      color: kBackground.withAlpha(200),
                      borderRadius: BorderRadius.circular(kRadiusStandard),
                      border: Border.all(color: kOutline),
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: kError,
                      size: 19.r,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: currentItem.imagePath != null
                  ? Image.file(
                      File(currentItem.imagePath!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _heroPlaceholder(),
                    )
                  : _heroPlaceholder(),
            ),
          ),

          // ── Content ─────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (currentItem.catalogueIdentifier != null)
                              Text(
                                currentItem.catalogueIdentifier!,
                                style: GoogleFonts.barlow(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: kAccent,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            SizedBox(height: 4.h),
                            Text(
                              currentItem.toolName ?? 'Unknown Tool',
                              style: GoogleFonts.barlow(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                                color: kPrimaryText,
                                height: 1.1,
                              ),
                            ),
                            if (currentItem.manufacturer != null)
                              Text(
                                currentItem.manufacturer!,
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: kSecondaryText,
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Condition badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: conditionColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(kRadiusPill),
                          border: Border.all(
                            color: conditionColor,
                            width: kStrokeWeightThin,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8.r,
                              height: 8.r,
                              decoration: BoxDecoration(
                                color: conditionColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              currentItem.conditionState?.displayName ??
                                  'Unknown',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: conditionColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Quick chips row
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (currentItem.toolType != null)
                        _chip(
                          Icons.build_outlined,
                          currentItem.toolType!.displayName,
                        ),
                      if (currentItem.operationMethod != null)
                        _chip(
                          Icons.settings_outlined,
                          currentItem.operationMethod!.displayName,
                        ),
                      if (currentItem.eraOfProduction != null)
                        _chip(
                          Icons.history_rounded,
                          currentItem.eraOfProduction!,
                        ),
                      if (currentItem.countryOfOrigin != null)
                        _chip(
                          Icons.flag_outlined,
                          currentItem.countryOfOrigin!,
                        ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // ── Sections ─────────────────────────────────────────────────
                  if (_hasProvenance(currentItem)) ...[
                    _sectionHeader('PROVENANCE'),
                    SizedBox(height: 12.h),
                    _infoPanel([
                      if (currentItem.manufacturer != null)
                        _row('Manufacturer', currentItem.manufacturer!),
                      if (currentItem.countryOfOrigin != null)
                        _row('Country', currentItem.countryOfOrigin!),
                      if (currentItem.eraOfProduction != null)
                        _row('Era', currentItem.eraOfProduction!),
                      if (currentItem.modelNumber != null)
                        _row('Model No.', currentItem.modelNumber!),
                      if (currentItem.serialNumber != null)
                        _row('Serial No.', currentItem.serialNumber!),
                    ]),
                    SizedBox(height: 20.h),
                  ],

                  if (_hasSpecs(currentItem)) ...[
                    _sectionHeader('TECHNICAL SPECS'),
                    SizedBox(height: 12.h),
                    _infoPanel([
                      if (currentItem.rebarSizeCapacity != null)
                        _row('Rebar Capacity', currentItem.rebarSizeCapacity!),
                      if (currentItem.bendAngleRange != null)
                        _row('Bend Range', currentItem.bendAngleRange!),
                      if (currentItem.material != null)
                        _row('Material', currentItem.material!),
                      if (currentItem.weight != null)
                        _row('Weight', currentItem.weight!),
                    ]),
                    SizedBox(height: 20.h),
                  ],

                  if (currentItem.provenance != null ||
                      currentItem.notes != null ||
                      currentItem.tags != null) ...[
                    _sectionHeader('NOTES'),
                    SizedBox(height: 12.h),
                    _infoPanel([
                      if (currentItem.provenance != null)
                        _row('Acquisition', currentItem.provenance!),
                      if (currentItem.notes != null)
                        _row('Notes', currentItem.notes!),
                      if (currentItem.tags != null)
                        _row('Tags', currentItem.tags!),
                    ]),
                    SizedBox(height: 20.h),
                  ],

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasProvenance(RebarToolModel currentItem) =>
      currentItem.manufacturer != null ||
      currentItem.countryOfOrigin != null ||
      currentItem.eraOfProduction != null ||
      currentItem.modelNumber != null ||
      currentItem.serialNumber != null;

  bool _hasSpecs(RebarToolModel currentItem) =>
      currentItem.rebarSizeCapacity != null ||
      currentItem.bendAngleRange != null ||
      currentItem.material != null ||
      currentItem.weight != null;

  Widget _heroPlaceholder() {
    return Container(
      color: kPanelBg,
      child: Center(
        child: Icon(Icons.build_circle_outlined, color: kMutedText, size: 64),
      ),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: kAccent),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: kSecondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String label) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: kAccent,
            borderRadius: BorderRadius.circular(kRadiusPill),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.barlow(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: kAccent,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: kMutedText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: kPrimaryText,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    RebarToolModel currentItem,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: kPanelBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusLarge),
          side: const BorderSide(color: kOutline),
        ),
        title: Text(
          'Delete Tool?',
          style: GoogleFonts.barlow(
            color: kPrimaryText,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        content: Text(
          'This action cannot be undone.',
          style: GoogleFonts.inter(color: kSecondaryText, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: GoogleFonts.barlow(
                color: kSecondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(projectProvider).deleteItem(currentItem.id!);
              if (context.mounted) {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back to home
              }
            },
            child: Text(
              'DELETE',
              style: GoogleFonts.barlow(
                color: kError,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

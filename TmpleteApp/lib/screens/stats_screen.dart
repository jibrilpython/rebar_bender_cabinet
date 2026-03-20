import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strain_guage_box/enum/my_enums.dart';
import 'package:strain_guage_box/models/strain_gauge_model.dart';
import 'package:strain_guage_box/providers/project_provider.dart';
import 'package:strain_guage_box/utils/const.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectProv = ref.watch(projectProvider);
    final entries = projectProv.entries;

    if (projectProv.isLoading) {
      return const Scaffold(
        backgroundColor: kBackground,
        body: Center(child: CircularProgressIndicator(color: kAccent)),
      );
    }

    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          SliverAppBar(
            expandedHeight: 120.h,
            stretch: true,
            backgroundColor: kBackground,
            elevation: 0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: _buildHeader(),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 140.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (entries.isEmpty)
                  _buildEmptyState()
                else ...[
                  _buildSummaryGauges(entries),
                  SizedBox(height: 28.h),
                  _buildSectionHeader('SYSTEM DISTRIBUTION'),
                  SizedBox(height: 16.h),
                  _buildTypeMachinedSlots(entries),
                  SizedBox(height: 28.h),
                  _buildSectionHeader('CONDITION SPREAD'),
                  SizedBox(height: 16.h),
                  _buildConditionPebbles(entries),
                  SizedBox(height: 28.h),
                  _buildSectionHeader('OPERATING ANALYTICS'),
                  SizedBox(height: 16.h),
                  _buildPrincipleMachinedSlots(entries),
                  SizedBox(height: 28.h),
                  _buildSectionHeader('ORIGIN ARCHIVE'),
                  SizedBox(height: 16.h),
                  _buildCountryStampGrid(entries),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      decoration: BoxDecoration(
        color: kBackground,
        border: Border(bottom: BorderSide(color: kSecondaryText.withValues(alpha: 0.1), width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildMachinedScrew(small: true),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ANALYTICS ENGINE',
                  style: GoogleFonts.specialElite(
                    color: kAccent,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                  ),
                ),
                Text(
                  'Archive Metrics',
                  style: GoogleFonts.inter(
                    color: kPrimaryText,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.query_stats_rounded, color: kSecondaryText.withValues(alpha: 0.2), size: 40.sp),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String label) {
    return Row(
      children: [
        _buildMachinedScrew(small: true, color: kAccent.withValues(alpha: 0.5)),
        SizedBox(width: 12.w),
        Text(
          label,
          style: GoogleFonts.specialElite(
            color: kSecondaryText,
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(child: Divider(color: kSecondaryText.withValues(alpha: 0.1), thickness: 1)),
      ],
    );
  }

  Widget _buildSummaryGauges(List<StrainGaugeModel> entries) {
    final total = entries.length;
    final operational = entries.where((e) => e.conditionState == ConditionState.operational).length;
    final ratio = total == 0 ? 0.0 : operational / total;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: const [
          BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-8, -8), blurRadius: 20),
          BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(8, 8), blurRadius: 20),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatPebble('LOGGED', '$total', kAccent),
                SizedBox(height: 20.h),
                _buildStatPebble('READY', '$operational', kSuccess),
              ],
            ),
          ),
          SizedBox(width: 20.w),
          _buildIndustrialRadialGauge(ratio),
        ],
      ),
    );
  }

  Widget _buildStatPebble(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: const [
          BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(3, 3), blurRadius: 6),
          BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-3, -3), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Container(width: 6.w, height: 24.h, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.specialElite(color: kSecondaryText, fontSize: 8.sp, fontWeight: FontWeight.w700)),
              Text(value, style: GoogleFonts.firaCode(color: kPrimaryText, fontSize: 20.sp, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndustrialRadialGauge(double percent) {
    return Container(
      width: 120.w,
      height: 120.w,
      padding: EdgeInsets.all(8.r),
      decoration: const BoxDecoration(
        color: kBackground,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(6, 6), blurRadius: 10),
          BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-6, -6), blurRadius: 10),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 90.w,
            height: 90.w,
            child: CircularProgressIndicator(
              value: percent,
              strokeWidth: 10.w,
              color: kAccent,
              backgroundColor: kOutline.withValues(alpha: 0.1),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${(percent * 100).toInt()}%', style: GoogleFonts.firaCode(color: kPrimaryText, fontSize: 18.sp, fontWeight: FontWeight.w900)),
              Text('READY', style: GoogleFonts.specialElite(color: kSecondaryText, fontSize: 8.sp, fontWeight: FontWeight.w700)),
            ],
          ),
          ...List.generate(4, (i) => Transform.rotate(
            angle: (i * 90) * 3.14 / 180,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(width: 2, height: 6.h, color: kSecondaryText.withValues(alpha: 0.2)),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTypeMachinedSlots(List<StrainGaugeModel> entries) {
    final Map<InstrumentType, int> counts = {};
    for (final e in entries) {
      counts[e.instrumentType] = (counts[e.instrumentType] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final maxCount = sorted.isEmpty ? 1 : sorted.first.value;

    return Column(
      children: sorted.map((entry) {
        final frac = entry.value / maxCount;
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: kBackground,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: const [
                BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(3, 3), blurRadius: 8),
                BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-3, -3), blurRadius: 8),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key.label.toUpperCase(), style: GoogleFonts.specialElite(color: kPrimaryText, fontSize: 10.sp, fontWeight: FontWeight.w700)),
                    Text('${entry.value}', style: GoogleFonts.firaCode(color: kAccent, fontSize: 12.sp, fontWeight: FontWeight.w800)),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  height: 14.h,
                  width: double.infinity,
                  padding: EdgeInsets.all(2.r),
                  decoration: BoxDecoration(
                    color: kBackground,
                    borderRadius: BorderRadius.circular(kRadiusPill),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(1, 1), blurRadius: 2),
                      BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-1, -1), blurRadius: 2),
                    ],
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: frac,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [getInstrumentTypeColor(entry.key), getInstrumentTypeColor(entry.key).withValues(alpha: 0.6)]),
                        borderRadius: BorderRadius.circular(kRadiusPill),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConditionPebbles(List<StrainGaugeModel> entries) {
     final Map<ConditionState, int> counts = {};
     for (final e in entries) {
       counts[e.conditionState] = (counts[e.conditionState] ?? 0) + 1;
     }
     
     return Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        children: ConditionState.values.map((state) {
          final count = counts[state] ?? 0;
          if (count == 0) return const SizedBox.shrink();
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: kBackground,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: const [
                BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(4, 4), blurRadius: 8),
                BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-4, -4), blurRadius: 8),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMachinedScrew(small: true, color: getConditionColor(state)),
                SizedBox(width: 8.w),
                Text(state.label, style: GoogleFonts.specialElite(color: kSecondaryText, fontSize: 10.sp, fontWeight: FontWeight.w700)),
                SizedBox(width: 12.w),
                Text('$count', style: GoogleFonts.firaCode(color: kPrimaryText, fontSize: 14.sp, fontWeight: FontWeight.w800)),
              ],
            ),
          );
        }).toList(),
     );
  }

  Widget _buildPrincipleMachinedSlots(List<StrainGaugeModel> entries) {
    final Map<OperatingPrinciple, int> counts = {};
    for (final e in entries) {
      counts[e.operatingPrinciple] = (counts[e.operatingPrinciple] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final maxCount = sorted.isEmpty ? 1 : sorted.first.value;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: kBackground,
        border: Border.all(color: kSecondaryText.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: sorted.map((entry) {
          final frac = entry.value / maxCount;
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              children: [
                Expanded(child: Text(entry.key.label, style: GoogleFonts.inter(color: kSecondaryText, fontSize: 11.sp, fontWeight: FontWeight.w500))),
                SizedBox(width: 12.w),
                Container(
                  width: 120.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: kBackground,
                    borderRadius: BorderRadius.circular(kRadiusPill),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(2, 2), blurRadius: 4),
                      BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-2, -2), blurRadius: 4),
                    ],
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: frac,
                    child: Container(color: kAccent, child: Center(child: Container(width: double.infinity, height: 1.h, color: Colors.white24))),
                  ),
                ),
                SizedBox(width: 12.w),
                Text('${entry.value}', style: GoogleFonts.firaCode(color: kPrimaryText, fontSize: 12.sp, fontWeight: FontWeight.w800)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCountryStampGrid(List<StrainGaugeModel> entries) {
    final Map<String, int> counts = {};
    for (final e in entries) {
      if (e.countryOfManufacture.isNotEmpty) {
        counts[e.countryOfManufacture] = (counts[e.countryOfManufacture] ?? 0) + 1;
      }
    }
    if (counts.isEmpty) return Center(child: Text('NO DATA', style: GoogleFonts.specialElite(color: kSecondaryText)));
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        mainAxisSpacing: 16.r,
        crossAxisSpacing: 16.r,
      ),
      itemCount: counts.length,
      itemBuilder: (context, index) {
        final key = counts.keys.elementAt(index);
        final val = counts[key];
        return Container(
          decoration: BoxDecoration(
            color: kBackground,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: const [
              BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(3, 3), blurRadius: 6),
              BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-3, -3), blurRadius: 6),
            ],
          ),
          child: Stack(
            children: [
              Positioned(right: -10, bottom: -10, child: Icon(Icons.public, color: kSecondaryText.withValues(alpha: 0.05), size: 60)),
              Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(key.toUpperCase(), style: GoogleFonts.specialElite(color: kSecondaryText, fontSize: 9.sp, fontWeight: FontWeight.w700)),
                    Text('$val UNITS', style: GoogleFonts.firaCode(color: kPrimaryText, fontSize: 13.sp, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMachinedScrew({bool small = false, Color? color}) {
    final size = small ? 14.w : 20.w;
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: kBackground,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(1, 1), blurRadius: 2),
          BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-1, -1), blurRadius: 2),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.7,
          height: 1.5.h,
          transform: Matrix4.rotationZ(0.78),
          color: color ?? kSecondaryText.withValues(alpha: 0.2),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
     return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100.h),
          _buildMachinedScrew(color: kAccent),
          SizedBox(height: 32.h),
          Text('AWAITING DATA', style: GoogleFonts.specialElite(color: kSecondaryText, fontSize: 14.sp, fontWeight: FontWeight.w700, letterSpacing: 2.0)),
          SizedBox(height: 12.h),
          Text('Log entry records to populate analysis engine.', style: GoogleFonts.inter(color: kSecondaryText.withValues(alpha: 0.6), fontSize: 12.sp)),
        ],
      ),
    );
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebar_bender_cabinet/enum/my_enums.dart';
import 'package:rebar_bender_cabinet/providers/project_provider.dart';
import 'package:rebar_bender_cabinet/utils/const.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Stats Screen — premium collection analytics dashboard
// ─────────────────────────────────────────────────────────────────────────────

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(projectProvider).allItems;
    final total = items.length;

    if (total == 0) {
      return Scaffold(
        backgroundColor: kBackground,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 80.r, height: 80.r,
              decoration: BoxDecoration(
                color: kPanelBg,
                shape: BoxShape.circle,
                border: Border.all(color: kOutline, width: kStrokeWeightMedium),
              ),
              child: Icon(Icons.analytics_outlined, size: 36.r, color: kMutedText),
            ),
            SizedBox(height: 20.h),
            Text('No data yet', style: GoogleFonts.barlow(
              fontSize: 20.sp, fontWeight: FontWeight.w700, color: kSecondaryText,
            )),
            SizedBox(height: 8.h),
            Text('Add tools to see your archive analytics.', style: GoogleFonts.inter(
              fontSize: 13.sp, color: kMutedText,
            )),
          ]),
        ),
      );
    }

    // Compute distributions
    final typeDist   = _distribute(items.map((e) => e.toolType?.displayName ?? 'Unknown'));
    final condDist   = _distribute(items.map((e) => e.conditionState?.displayName ?? 'Unknown'));
    final methodDist = _distribute(items.map((e) => e.operationMethod?.displayName ?? 'Unknown'));
    final uniqueCountries = _countUnique(items.map((e) => e.countryOfOrigin));
    final uniqueEras      = _countUnique(items.map((e) => e.eraOfProduction));

    // Best condition
    final topCondition = condDist.entries.isEmpty
        ? 'N/A'
        : (condDist.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first.key;

    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ─────────────────────────────────────────────────────────
          SliverAppBar(
            backgroundColor: kBackground,
            pinned: true,
            floating: false,
            expandedHeight: 120.h,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [kBackground, kSurface],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 52.h, 20.w, 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('ANALYTICS', style: GoogleFonts.barlow(
                        fontSize: 10.sp, fontWeight: FontWeight.w700,
                        color: kAccent, letterSpacing: 3.5,
                      )),
                      SizedBox(height: 2.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('Collection', style: GoogleFonts.barlow(
                            fontSize: 26.sp, fontWeight: FontWeight.w900, color: kPrimaryText,
                          )),
                          SizedBox(width: 8.w),
                          Text('Insights', style: GoogleFonts.barlow(
                            fontSize: 26.sp, fontWeight: FontWeight.w300, color: kSecondaryText,
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Hero KPI Row ───────────────────────────────────────────────
                _heroKpiRow(total, uniqueCountries, uniqueEras, topCondition),
                SizedBox(height: 20.h),

                // ── Condition Donut ────────────────────────────────────────────
                _conditionDonutSection(condDist, total),
                SizedBox(height: 20.h),

                // ── Tool Types capsule bars ────────────────────────────────────
                _capsuleBarSection('TOOL TYPES', typeDist, total, kAccent),
                SizedBox(height: 20.h),

                // ── Operation Methods ──────────────────────────────────────────
                _capsuleBarSection('OPERATION METHODS', methodDist, total, kAccentLight),

              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero KPI row ────────────────────────────────────────────────────────────
  Widget _heroKpiRow(int total, int countries, int eras, String topCondition) {
    return Column(children: [
      // Large primary KPI
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2E2218), Color(0xFF3A2B1A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(kRadiusXLarge),
          border: Border.all(color: kAccentOutline, width: kStrokeWeightMedium),
          boxShadow: kShadowAccent,
        ),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('TOTAL TOOLS', style: GoogleFonts.barlow(
                fontSize: 10.sp, fontWeight: FontWeight.w700,
                color: kAccentLight, letterSpacing: 2.5,
              )),
              SizedBox(height: 4.h),
              Text('$total', style: GoogleFonts.barlow(
                fontSize: 56.sp, fontWeight: FontWeight.w900,
                color: kPrimaryText, height: 1.0,
              )),
              SizedBox(height: 4.h),
              Text('items catalogued', style: GoogleFonts.inter(
                fontSize: 12.sp, color: kMutedText,
              )),
            ]),
          ),
          // Decorative arc
          SizedBox(
            width: 64.r, height: 64.r,
            child: CustomPaint(painter: _ArcPainter(kAccent, 0.72)),
          ),
        ]),
      ),

      SizedBox(height: 12.h),

      // 3 secondary KPIs
      Row(children: [
        _kpiTile(Icons.public_outlined, '$countries', 'Countries'),
        SizedBox(width: 10.w),
        _kpiTile(Icons.history_edu_rounded, '$eras', 'Eras'),
        SizedBox(width: 10.w),
        _kpiTileFlex(Icons.stars_rounded, topCondition, 'Top Condition', kSuccess),
      ]),
    ]);
  }

  Widget _kpiTile(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: kPanelBg,
          borderRadius: BorderRadius.circular(kRadiusLarge),
          border: Border.all(color: kAccentOutline, width: kStrokeWeightThin),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: kAccent, size: 18.r),
          SizedBox(height: 8.h),
          Text(value, style: GoogleFonts.barlow(
            fontSize: 28.sp, fontWeight: FontWeight.w900, color: kPrimaryText, height: 1.0,
          )),
          SizedBox(height: 2.h),
          Text(label, style: GoogleFonts.inter(fontSize: 10.sp, color: kMutedText)),
        ]),
      ),
    );
  }

  Widget _kpiTileFlex(IconData icon, String value, String label, Color accentColor) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: kPanelBg,
          borderRadius: BorderRadius.circular(kRadiusLarge),
          border: Border.all(color: kAccentOutline, width: kStrokeWeightThin),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: accentColor, size: 18.r),
          SizedBox(height: 8.h),
          Text(
            value,
            style: GoogleFonts.barlow(
              fontSize: value.length > 6 ? 14.sp : 18.sp,
              fontWeight: FontWeight.w800,
              color: accentColor,
              height: 1.1,
            ),
            maxLines: 2,
          ),
          SizedBox(height: 2.h),
          Text(label, style: GoogleFonts.inter(fontSize: 10.sp, color: kMutedText)),
        ]),
      ),
    );
  }

  // ── Condition Donut + legend ──────────────────────────────────────────────
  Widget _conditionDonutSection(Map<String, int> dist, int total) {
    final ordered = ConditionState.values
        .map((s) => MapEntry(s, dist[s.displayName] ?? 0))
        .where((e) => e.value > 0)
        .toList();

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: kPanelBg,
        borderRadius: BorderRadius.circular(kRadiusXLarge),
        border: Border.all(color: kAccentOutline, width: kStrokeWeightThin),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionHeader('CONDITION', kSuccess),
        SizedBox(height: 20.h),

        Row(children: [
          // Donut chart
          SizedBox(
            width: 120.r, height: 120.r,
            child: CustomPaint(
              painter: _DonutPainter(
                segments: ordered.map((e) => e.value / total).toList(),
                colors: ordered.map((e) =>
                    kConditionColors[e.key.name] ?? kSecondaryText).toList(),
              ),
              child: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('$total', style: GoogleFonts.barlow(
                    fontSize: 22.sp, fontWeight: FontWeight.w900, color: kPrimaryText,
                  )),
                  Text('total', style: GoogleFonts.inter(
                    fontSize: 9.sp, color: kMutedText, letterSpacing: 1.0,
                  )),
                ]),
              ),
            ),
          ),

          SizedBox(width: 20.w),

          // Legend
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ordered.map((entry) {
                final color = kConditionColors[entry.key.name] ?? kSecondaryText;
                final pct   = (entry.value / total * 100).round();
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(children: [
                    Container(
                      width: 10.r, height: 10.r,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(entry.key.displayName, style: GoogleFonts.inter(
                        fontSize: 11.sp, color: kSecondaryText,
                      )),
                    ),
                    Text('$pct%', style: GoogleFonts.barlow(
                      fontSize: 12.sp, fontWeight: FontWeight.w700, color: kPrimaryText,
                    )),
                  ]),
                );
              }).toList(),
            ),
          ),
        ]),
      ]),
    );
  }

  // ── Thick Capsule Bar Section ─────────────────────────────────────────────
  Widget _capsuleBarSection(String title, Map<String, int> dist, int total, Color barColor) {
    final sorted = dist.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: kPanelBg,
        borderRadius: BorderRadius.circular(kRadiusXLarge),
        border: Border.all(color: kAccentOutline, width: kStrokeWeightThin),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionHeader(title, barColor),
        SizedBox(height: 16.h),
        ...sorted.asMap().entries.map((entry) {
          final i   = entry.key;
          final e   = entry.value;
          final pct = total > 0 ? e.value / total : 0.0;
          // Slightly desaturate bars after the first
          final color = i == 0 ? barColor : barColor.withAlpha(160 - (i * 20).clamp(0, 100));

          return Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Text(e.key, style: GoogleFonts.inter(
                    fontSize: 12.sp, fontWeight: FontWeight.w500, color: kSecondaryText,
                  )),
                ),
                SizedBox(width: 8.w),
                Text('${e.value}', style: GoogleFonts.barlow(
                  fontSize: 14.sp, fontWeight: FontWeight.w800, color: kPrimaryText,
                )),
                SizedBox(width: 4.w),
                Text('(${(pct * 100).round()}%)', style: GoogleFonts.inter(
                  fontSize: 10.sp, color: kMutedText,
                )),
              ]),
              SizedBox(height: 6.h),
              LayoutBuilder(builder: (ctx, constraints) {
                return Stack(children: [
                  // Track
                  Container(
                    height: 10.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kRaisedBg,
                      borderRadius: BorderRadius.circular(kRadiusPill),
                    ),
                  ),
                  // Fill (animated)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 600 + i * 100),
                    curve: Curves.easeOutCubic,
                    height: 10.h,
                    width: constraints.maxWidth * pct,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(kRadiusPill),
                      boxShadow: [
                        BoxShadow(
                          color: color.withAlpha(100),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ]);
              }),
            ]),
          );
        }),
      ]),
    );
  }

  Widget _sectionHeader(String title, Color accentColor) {
    return Row(children: [
      Container(
        width: 3.w, height: 14.h,
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(kRadiusPill),
        ),
      ),
      SizedBox(width: 8.w),
      Text(title, style: GoogleFonts.barlow(
        fontSize: 10.sp, fontWeight: FontWeight.w800,
        color: accentColor, letterSpacing: 2.5,
      )),
    ]);
  }

  Map<String, int> _distribute(Iterable<String> values) {
    final map = <String, int>{};
    for (final v in values) {
      map[v] = (map[v] ?? 0) + 1;
    }
    return map;
  }

  int _countUnique(Iterable<String?> values) =>
      values.where((v) => v != null && v.isNotEmpty).toSet().length;
}

// ─────────────────────────────────────────────────────────────────────────────
//  Custom Painters
// ─────────────────────────────────────────────────────────────────────────────

/// Decorative partial arc used in the hero KPI card
class _ArcPainter extends CustomPainter {
  final Color color;
  final double fraction; // 0.0 – 1.0

  const _ArcPainter(this.color, this.fraction);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      math.pi * 1.5,
      false,
      Paint()
        ..color = kRaisedBg
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );
    // Fill
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      math.pi * 1.5 * fraction,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter old) => old.fraction != fraction;
}

/// Multi-segment donut chart for condition breakdown
class _DonutPainter extends CustomPainter {
  final List<double> segments; // fractions 0-1 for each segment
  final List<Color> colors;

  const _DonutPainter({required this.segments, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 16.0;
    const gapAngle = 0.04; // radians between segments

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -math.pi / 2;
    final totalGap = gapAngle * segments.length;
    final availableAngle = (2 * math.pi) - totalGap;

    for (var i = 0; i < segments.length; i++) {
      final sweep = segments[i] * availableAngle;
      paint.color = colors[i];

      // Track (dim)
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        Paint()
          ..color = colors[i].withAlpha(40)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
      // Fill
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        paint,
      );

      startAngle += sweep + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) => true;
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebar_bender_cabinet/models/rebar_tool_model.dart';
import 'package:rebar_bender_cabinet/providers/image_provider.dart';
import 'package:rebar_bender_cabinet/providers/input_provider.dart';
import 'package:rebar_bender_cabinet/providers/project_provider.dart';
import 'package:rebar_bender_cabinet/screens/add_screen.dart';
import 'package:rebar_bender_cabinet/screens/info_screen.dart';
import 'package:rebar_bender_cabinet/providers/search_provider.dart';
import 'package:rebar_bender_cabinet/utils/const.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Home Screen — premium archive grid with hero header & filter chips
// ─────────────────────────────────────────────────────────────────────────────

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _searchCtrl = TextEditingController();
  bool _searchActive = false;
  late AnimationController _fabAnim;
  late Animation<double> _fabScale;

  @override
  void initState() {
    super.initState();
    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fabScale = CurvedAnimation(parent: _fabAnim, curve: Curves.elasticOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(projectProvider).loadItems();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _fabAnim.dispose();
    super.dispose();
  }

  void _goToAdd() {
    ref.read(inputProvider).clearAll();
    ref.read(imageProvider).clearImage();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddScreen(isEdit: false)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(projectProvider);
    final search = ref.watch(searchProvider);
    final allItems = project.allItems;
    final items = search.filter(allItems);

    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        slivers: [
          // ── Hero App Bar ───────────────────────────────────────────────────
          _buildHeroAppBar(allItems.length, _calculateEraRange(allItems)),

          // ── Search Bar (shown when active) ─────────────────────────────────
          if (_searchActive)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                child: _buildSearchBar(),
              ),
            ),

          // ── Content ────────────────────────────────────────────────────────
          if (allItems.isEmpty)
            SliverFillRemaining(child: _buildEmptyState())
          else if (items.isEmpty)
            SliverFillRemaining(child: _buildNoResultsState())
          else ...[
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18.w,
                  mainAxisSpacing: 18.h,
                  childAspectRatio: 0.65,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _buildToolCard(items[i]),
                  childCount: items.length,
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 80.h)),
          ],
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabScale,
        child: _buildFAB(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // ── Hero App Bar ─────────────────────────────────────────────────────────
  SliverAppBar _buildHeroAppBar(int totalCount, String eraRange) {
    return SliverAppBar(
      backgroundColor: kBackground,
      pinned: true,
      floating: false,
      snap: false,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      expandedHeight: 0, // no flexible space — content lives in title + bottom
      toolbarHeight: 88.h,
      titleSpacing: 20.w,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'THE ARCHIVE',
            style: GoogleFonts.barlow(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: kAccent,
              letterSpacing: 3.5,
            ),
          ),
          Text(
            'Rebar Benders',
            style: GoogleFonts.barlow(
              fontSize: 28.sp,
              fontWeight: FontWeight.w900,
              color: kPrimaryText,
              height: 1.1,
            ),
          ),
        ],
      ),
      actions: [
        // Search toggle
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: GestureDetector(
            onTap: () {
              setState(() => _searchActive = !_searchActive);
              if (!_searchActive) {
                _searchCtrl.clear();
                ref.read(searchProvider).setQuery('');
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: _searchActive ? kAccentMuted : kPanelBg,
                borderRadius: BorderRadius.circular(kRadiusStandard),
                border: Border.all(
                  color: _searchActive ? kAccent : kAccentOutline,
                  width: kStrokeWeightMedium,
                ),
                boxShadow: _searchActive ? kShadowAccent : kShadowSoft,
              ),
              child: Icon(
                _searchActive ? Icons.close_rounded : Icons.search_rounded,
                color: _searchActive ? kAccent : kSecondaryText,
                size: 19.r,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
          decoration: const BoxDecoration(
            color: kBackground,
            border: Border(
              bottom: BorderSide(color: kOutline, width: kStrokeWeightThin),
            ),
          ),
          child: Row(
            children: [
              _countBadge(totalCount),
              SizedBox(width: 10.w),
              _infoBadge(Icons.calendar_month_outlined, eraRange),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateEraRange(List<RebarToolModel> items) {
    if (items.isEmpty) return 'No Era Data';

    final eras = items
        .map((e) => e.eraOfProduction)
        .where((e) => e != null && e.isNotEmpty)
        .cast<String>()
        .toList();

    if (eras.isEmpty) return 'Unknown Era';
    if (eras.length == 1) return eras.first;

    final yearRegex = RegExp(r'\d{4}');
    final years =
        eras
            .map((e) {
              final match = yearRegex.firstMatch(e);
              return match != null ? int.tryParse(match.group(0)!) : null;
            })
            .whereType<int>()
            .toList()
          ..sort();

    if (years.isEmpty) {
      final uniqueEras = eras.toSet().toList();
      if (uniqueEras.length <= 2) return uniqueEras.join(' – ');
      return 'Various Eras';
    }

    final minYear = years.first;
    final maxYear = years.last;

    if (minYear == maxYear) return '${minYear}s';
    final start = minYear.toString().endsWith('0') ? '${minYear}s' : '$minYear';
    final end = maxYear.toString().endsWith('0') ? '${maxYear}s' : '$maxYear';
    if (start == end) return start;
    return '$start – $end';
  }

  Widget _countBadge(int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3A2B1A), Color(0xFF2E2218)],
        ),
        borderRadius: BorderRadius.circular(kRadiusPill),
        border: Border.all(color: kAccentOutline, width: kStrokeWeightThin),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, color: kAccent, size: 12.r),
          SizedBox(width: 6.w),
          Text(
            '$count ${count == 1 ? 'tool' : 'tools'}',
            style: GoogleFonts.barlow(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: kAccentLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBadge(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: kPanelBg,
        borderRadius: BorderRadius.circular(kRadiusPill),
        border: Border.all(color: kOutline, width: kStrokeWeightThin),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: kMutedText, size: 12.r),
          SizedBox(width: 6.w),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 11.sp, color: kSecondaryText),
          ),
        ],
      ),
    );
  }

  // ── Search Bar ─────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: kPanelBg,
        borderRadius: BorderRadius.circular(kRadiusLarge),
        border: Border.all(color: kAccent, width: kStrokeWeightMedium),
        boxShadow: kShadowAccent,
      ),
      child: TextField(
        controller: _searchCtrl,
        autofocus: true,
        style: GoogleFonts.inter(fontSize: 14.sp, color: kPrimaryText),
        decoration: InputDecoration(
          hintText: 'Search tools, manufacturers, eras…',
          hintStyle: GoogleFonts.inter(fontSize: 13.sp, color: kMutedText),
          prefixIcon: Icon(Icons.search_rounded, color: kAccent, size: 18.r),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
        keyboardType: TextInputType.text,
        inputFormatters: null,
        onChanged: (v) => ref.read(searchProvider).setQuery(v),
      ),
    );
  }

  // ── Tool Card ──────────────────────────────────────────────────────────────
  Widget _buildToolCard(RebarToolModel item) {
    final hasImage = item.imagePath != null;
    final conditionColor =
        kConditionColors[item.conditionState?.name] ?? kSecondaryText;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => InfoScreen(item: item)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: kPanelBg,
          borderRadius: BorderRadius.circular(kRadiusLarge),
          border: Border.all(color: kAccentOutline, width: kStrokeWeightThin),
          boxShadow: kShadowSoft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ─────────────────────────────────────────────────────
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(kRadiusLarge),
                    ),
                    child: hasImage
                        ? Image.file(
                            File(item.imagePath as String),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _buildImagePlaceholder(),
                          )
                        : _buildImagePlaceholder(),
                  ),

                  // Catalogue ID badge (top-left)
                  if (item.catalogueIdentifier != null)
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 120.w),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: kBackground.withAlpha(200),
                            borderRadius: BorderRadius.circular(kRadiusPill),
                            border: Border.all(
                              color: kAccentOutline,
                              width: kStrokeWeightThin,
                            ),
                          ),
                          child: Text(
                            item.catalogueIdentifier!,
                            style: GoogleFonts.barlow(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                              color: kAccent,
                              letterSpacing: 1.0,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),

                  // Gradient overlay at bottom of image
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 36.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [kPanelBg, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info ──────────────────────────────────────────────────────
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.w, 6.h, 10.w, 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.toolName ?? 'Unknown Tool',
                      style: GoogleFonts.barlow(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: kPrimaryText,
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item.manufacturer ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: kSecondaryText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Bottom row
                    Row(
                      children: [
                        if (item.eraOfProduction != null) ...[
                          Icon(
                            Icons.history_rounded,
                            size: 10.r,
                            color: kMutedText,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            item.eraOfProduction!,
                            style: GoogleFonts.inter(
                              fontSize: 9.sp,
                              color: kMutedText,
                            ),
                          ),
                          const Spacer(),
                        ],
                        // Condition pill
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: conditionColor.withAlpha(30),
                            borderRadius: BorderRadius.circular(kRadiusPill),
                            border: Border.all(
                              color: conditionColor.withAlpha(120),
                              width: kStrokeWeightThin,
                            ),
                          ),
                          child: Text(
                            item.conditionState?.displayName ?? '—',
                            style: GoogleFonts.inter(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                              color: conditionColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kRaisedBg, kSurface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.build_circle_outlined, color: kMutedText, size: 30.r),
            SizedBox(height: 4.h),
            Text(
              'No photo',
              style: GoogleFonts.inter(fontSize: 9.sp, color: kMutedText),
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty State ─────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decorative icon with glow
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 110.r,
                  height: 110.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kAccent.withAlpha(20),
                  ),
                ),
                Container(
                  width: 80.r,
                  height: 80.r,
                  decoration: BoxDecoration(
                    color: kPanelBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: kAccentOutline,
                      width: kStrokeWeightMedium,
                    ),
                  ),
                  child: Icon(
                    Icons.precision_manufacturing_outlined,
                    size: 34.r,
                    color: kAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text(
              'Your Archive Awaits',
              style: GoogleFonts.barlow(
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                color: kPrimaryText,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Start cataloguing your rebar\nbending tool collection.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: kSecondaryText,
                height: 1.6,
              ),
            ),
            SizedBox(height: 32.h),
            GestureDetector(
              onTap: _goToAdd,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kAccentLight, kAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(kRadiusPill),
                  boxShadow: kShadowAccent,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, color: kBackground, size: 18.r),
                    SizedBox(width: 8.w),
                    Text(
                      'ADD FIRST TOOL',
                      style: GoogleFonts.barlow(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: kBackground,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── No Results ──────────────────────────────────────────────────────────────
  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70.r,
            height: 70.r,
            decoration: BoxDecoration(
              color: kPanelBg,
              shape: BoxShape.circle,
              border: Border.all(color: kOutline, width: kStrokeWeightThin),
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 28.r,
              color: kMutedText,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No tools found',
            style: GoogleFonts.barlow(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: kSecondaryText,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Try a different search term.',
            style: GoogleFonts.inter(fontSize: 13.sp, color: kMutedText),
          ),
        ],
      ),
    );
  }

  // ── FAB ─────────────────────────────────────────────────────────────────────
  Widget _buildFAB() {
    return GestureDetector(
      onTap: _goToAdd,
      child: Container(
        width: 60.r,
        height: 60.r,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kAccentLight, kAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(kRadiusLarge),
          boxShadow: kShadowAccent,
        ),
        child: Icon(Icons.add_rounded, color: kBackground, size: 30.r),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strain_guage_box/enum/my_enums.dart';
import 'package:strain_guage_box/models/strain_gauge_model.dart';
import 'package:strain_guage_box/providers/image_provider.dart';
import 'package:strain_guage_box/providers/project_provider.dart';
import 'package:strain_guage_box/providers/search_provider.dart';
import 'package:strain_guage_box/utils/const.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  InstrumentType? _selectedFilter;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProv = ref.watch(searchProvider);
    final projectProv = ref.watch(projectProvider);
    final allEntries = projectProv.entries;

    List<StrainGaugeModel> filteredByType = _selectedFilter == null
        ? allEntries
        : allEntries.where((e) => e.instrumentType == _selectedFilter).toList();
    final entries = searchProv.filteredList(filteredByType);

    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        slivers: [
          SliverAppBar(
            expandedHeight: 180.h,
            stretch: true,
            // backgroundColor: kBackground,
            elevation: 0,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              background: _buildWelcomeBanner(allEntries.length),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  _buildRevampedSearchBar(),
                  SizedBox(height: 12.h),
                  _buildSoftFilterChips(),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
          entries.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(),
                )
              : SliverPadding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 140.h),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = entries[index];
                        final mainIndex =
                            ref.read(projectProvider).entries.indexOf(entry);
                        return _buildPebbleCard(context, entry, mainIndex);
                      },
                      childCount: entries.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner(int count) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 30.h),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kAccent,
              kAccent.withValues(alpha: 0.8),
              const Color(0xFF1D3557),
            ],
          ),
          boxShadow: [
            BoxShadow(
              // color: kAccent.withValues(alpha: 0.3),
              color:
                  const Color.fromRGBO(224, 229, 236, 1).withValues(alpha: 0.3),
              offset: const Offset(0, 10),
              blurRadius: 20,
            ),
          ],
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r),
              bottomRight: Radius.circular(24.r))),
      child: Row(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Your Archive',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(kRadiusPill),
                    ),
                    child: Text(
                      '$count INSTRUMENTS LOGGED',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/add_screen'),
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white, size: 32.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevampedSearchBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 56.h,
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(28.h),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFFFFFFF),
            offset: Offset(-4, -4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Color(0xFFA3B1C6),
            offset: Offset(4, 4),
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.h),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: (v) => ref.read(searchProvider.notifier).setSearchQuery(v),
          style: GoogleFonts.inter(
            color: kPrimaryText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Search the collection...',
            hintStyle: GoogleFonts.inter(
              color: kSecondaryText.withValues(alpha: 0.5),
              fontSize: 14.sp,
            ),
            prefixIcon: Container(
              margin: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: kAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_rounded,
                color: kAccent,
                size: 18.sp,
              ),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: kSecondaryText.withValues(alpha: 0.5),
                      size: 18.sp,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(searchProvider.notifier).clearSearchQuery();
                      setState(() {});
                    },
                  )
                : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.symmetric(vertical: 18.h),
          ),
        ),
      ),
    );
  }

  Widget _buildSoftFilterChips() {
    return SizedBox(
      height: 65.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 1.h),
        children: [
          _buildPillTab('ALL', null),
          ...InstrumentType.values.map((t) => _buildPillTab(t.label, t)),
        ],
      ),
    );
  }

  Widget _buildPillTab(String label, InstrumentType? type) {
    final isSelected = _selectedFilter == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.only(right: 12.w, top: 10.h, bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: isSelected ? kAccent : kBackground,
          borderRadius: BorderRadius.circular(kRadiusPill),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: kAccent.withValues(alpha: 0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 6)
                ]
              : const [
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
            label.toUpperCase(),
            style: GoogleFonts.inter(
              color: isSelected ? kPanelBg : kSecondaryText,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPebbleCard(
      BuildContext context, StrainGaugeModel entry, int index) {
    final imageProv = ref.watch(imageProvider);
    final imagePath = imageProv.getImagePath(entry.photoPath);
    final conditionColor = getConditionColor(entry.conditionState);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/info_screen',
          arguments: {'index': index}),
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        height: 110.h,
        decoration: BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.circular(30), // Pebble curve
          boxShadow: const [
            BoxShadow(
                color: Color(0xFFFFFFFF),
                offset: Offset(-6, -6),
                blurRadius: 15),
            BoxShadow(
                color: Color(0xFFA3B1C6), offset: Offset(6, 6), blurRadius: 15),
          ],
        ),
        child: Row(
          children: [
            // Image Node
            Container(
              width: 100.w,
              height: 110.h,
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(30)),
              ),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(30)),
                child: (entry.photoPath.isNotEmpty &&
                        imagePath != null &&
                        File(imagePath).existsSync())
                    ? Image.file(File(imagePath), fit: BoxFit.cover)
                    : Container(
                        color: kOutline.withValues(alpha: 0.2),
                        child: Icon(Icons.photo_outlined,
                            color: kSecondaryText.withValues(alpha: 0.3),
                            size: 30.sp),
                      ),
              ),
            ),

            // Info Node
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: conditionColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: conditionColor.withValues(alpha: 0.4),
                                  blurRadius: 4)
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            entry.instrumentName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: kPrimaryText,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      entry.manufacturer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: kSecondaryText,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          entry.instrumentType.label.toUpperCase(),
                          style: GoogleFonts.inter(
                            color: kAccent,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: kBackground,
                            borderRadius: BorderRadius.circular(kRadiusPill),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0xFFA3B1C6),
                                  offset: Offset(2, 2),
                                  blurRadius: 4),
                              BoxShadow(
                                  color: Color(0xFFFFFFFF),
                                  offset: Offset(-2, -2),
                                  blurRadius: 4),
                            ],
                          ),
                          child: Text(
                            '${entry.yearOfManufacture}',
                            style: GoogleFonts.inter(
                              color: kPrimaryText,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50.h),
          Container(
            width: 120.w,
            height: 120.w,
            decoration: const BoxDecoration(
              color: kBackground,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Color(0xFFA3B1C6),
                    offset: Offset(8, 8),
                    blurRadius: 16),
                BoxShadow(
                    color: Color(0xFFFFFFFF),
                    offset: Offset(-8, -8),
                    blurRadius: 16),
              ],
            ),
            child: Icon(Icons.wind_power_rounded,
                size: 48.sp, color: kAccent.withValues(alpha: 0.2)),
          ),
          SizedBox(height: 32.h),
          Text(
            'NOTHING HERE YET',
            style: GoogleFonts.inter(
              color: kSecondaryText,
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.5,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Tap the (+) to begin collecting.',
            style: GoogleFonts.inter(
              color: kSecondaryText.withValues(alpha: 0.6),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

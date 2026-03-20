import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebar_bender_cabinet/screens/home_screen.dart';
import 'package:rebar_bender_cabinet/screens/showcase_screen.dart';
import 'package:rebar_bender_cabinet/screens/stats_screen.dart';
import 'package:rebar_bender_cabinet/utils/const.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Main Navigation — premium bottom nav shell
// ─────────────────────────────────────────────────────────────────────────────

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    StatsScreen(),
    ShowcaseScreen(),
  ];

  static const _navItems = [
    (icon: Icons.grid_view_rounded, outlinedIcon: Icons.grid_view_outlined, label: 'Archive'),
    (icon: Icons.bar_chart_rounded, outlinedIcon: Icons.bar_chart_outlined, label: 'Stats'),
    (icon: Icons.view_carousel_rounded, outlinedIcon: Icons.view_carousel_outlined, label: 'Showcase'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        border: const Border(
          top: BorderSide(color: kOutline, width: kStrokeWeightThin),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(120),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            children: [
              for (int i = 0; i < _navItems.length; i++) _buildNavItem(i),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isActive = _currentIndex == index;
    final item = _navItems[index];

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _currentIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isActive ? kAccentMuted : Colors.transparent,
            borderRadius: BorderRadius.circular(kRadiusLarge),
            border: isActive
                ? Border.all(color: kAccentOutline, width: kStrokeWeightThin)
                : null,
            boxShadow: isActive ? kShadowAccent : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isActive ? item.icon : item.outlinedIcon,
                  key: ValueKey(isActive),
                  color: isActive ? kAccent : kMutedText,
                  size: 22.r,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                item.label,
                style: GoogleFonts.barlow(
                  fontSize: 10.sp,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? kAccent : kMutedText,
                  letterSpacing: isActive ? 0.8 : 0.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

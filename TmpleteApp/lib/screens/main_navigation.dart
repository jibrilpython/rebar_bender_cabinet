import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strain_guage_box/screens/home_screen.dart';
import 'package:strain_guage_box/screens/stats_screen.dart';
import 'package:strain_guage_box/screens/showcase_screen.dart';
import 'package:strain_guage_box/utils/const.dart';

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const StatsScreen(),
    const ShowcaseScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          // Floating Bottom Nav
          Positioned(
            left: 30.w,
            right: 30.w,
            bottom: 30.h,
            child: _buildFloatingNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavBar() {
    final isShowcase = _currentIndex == 2;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 64.h,
      decoration: BoxDecoration(
        color: isShowcase ? kHammerDark : kBackground,
        borderRadius: BorderRadius.circular(kRadiusPill),
        boxShadow: isShowcase
            ? [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    offset: const Offset(4, 4),
                    blurRadius: 10),
                BoxShadow(
                    color: Colors.white.withValues(alpha: 0.05),
                    offset: const Offset(-4, -4),
                    blurRadius: 10),
              ]
            : const [
                BoxShadow(
                    color: Color(0xFFFFFFFF),
                    offset: Offset(-4, -4),
                    blurRadius: 10),
                BoxShadow(
                    color: Color(0xFFA3B1C6),
                    offset: Offset(4, 4),
                    blurRadius: 10),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.grid_view_rounded),
          _buildNavItem(1, Icons.bar_chart_rounded),
          _buildNavItem(2, Icons.view_carousel_rounded),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = _currentIndex == index;
    final isShowcase = _currentIndex == 2;

    Color activeColor = isShowcase ? kBrass : kAccent;
    Color inactiveColor =
        isShowcase ? Colors.white24 : kSecondaryText.withValues(alpha: 0.5);

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isSelected
              ? (isShowcase ? kHammerDark : kBackground)
              : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? (isShowcase
                  ? [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(2, 2),
                          blurRadius: 4),
                      BoxShadow(
                          color: Colors.white.withValues(alpha: 0.02),
                          offset: const Offset(-2, -2),
                          blurRadius: 4),
                    ]
                  : const [
                      BoxShadow(
                          color: Color(0xFFA3B1C6),
                          offset: Offset(2, 2),
                          blurRadius: 4),
                      BoxShadow(
                          color: Color(0xFFFFFFFF),
                          offset: Offset(-2, -2),
                          blurRadius: 4),
                    ])
              : null,
        ),
        child: Icon(
          icon,
          color: isSelected ? activeColor : inactiveColor,
          size: 24.sp,
        ),
      ),
    );
  }
}

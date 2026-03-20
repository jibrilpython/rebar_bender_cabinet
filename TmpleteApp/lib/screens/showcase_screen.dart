import 'dart:io';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strain_guage_box/models/strain_gauge_model.dart';
import 'package:strain_guage_box/providers/image_provider.dart';
import 'package:strain_guage_box/providers/project_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:strain_guage_box/utils/const.dart';

// ─── TACTILE SKEUOMORPHISM PALETTE (Imported from const.dart) ────────────────

class ShowcaseScreen extends ConsumerStatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  ConsumerState<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends ConsumerState<ShowcaseScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  
  // Gyroscope
  StreamSubscription? _gyroSub;
  double _gyroRotation = 0.0;
  
  // Vertical Tension (Scroll Velocity)
  late Ticker _ticker;
  double _velocity = 0.0;
  
  final math.Random _random = math.Random(42); // Seeded for consistent screw rotation

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);

    // Track gyroscope for mechanical diagram rotation
    _gyroSub = gyroscopeEventStream().listen((GyroscopeEvent event) {
      if (!mounted) return;
      setState(() {
         // Accumulate rotation. y-axis usually corresponds to device twist
         _gyroRotation += event.y * 0.02; 
      });
    });

    // Ticker to decay velocity back to 0 (spring effect)
    _ticker = createTicker((elapsed) {
       if (_velocity.abs() > 0.5) {
         setState(() {
           _velocity *= 0.85; // Friction decay
         });
       } else if (_velocity != 0) {
         setState(() => _velocity = 0);
       }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _gyroSub?.cancel();
    _ticker.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectProv = ref.watch(projectProvider);
    final entries = projectProv.entries;
    final imageProv = ref.watch(imageProvider);

    return Scaffold(
      // Hammer-tone industrial steel background
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [kHammerLight, kHammerDark],
            center: Alignment.center,
            radius: 1.5,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTactileHeader(entries),
              if (entries.isEmpty)
                Expanded(child: _buildEmptyState())
              else
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollUpdateNotification) {
                        setState(() {
                          // Capture scroll delta for tension effect
                          _velocity = notification.scrollDelta ?? 0.0;
                        });
                      }
                      return false;
                    },
                    child: PageView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _pageController,
                      itemCount: entries.length,
                      onPageChanged: (i) => setState(() => _currentIndex = i),
                      itemBuilder: (context, index) {
                        // Calculate distance from center for subtle parallax
                        double pageOffset = 0;
                        if (_pageController.position.haveDimensions) {
                          pageOffset = _pageController.page! - index;
                        }
                        return _buildHighPolyPressurePlate(
                            context, entries[index], imageProv, index, pageOffset);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTactileHeader(List<StrainGaugeModel> entries) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: kBrass.withValues(alpha: 0.1),
        border: Border.all(color: kBrass.withValues(alpha: 0.3), width: 2),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          _buildScrew(),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FIELD SHOWCASE',
                style: GoogleFonts.specialElite(
                  color: kBrassLight,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3.0,
                ),
              ),
              Text(
                'PHYSICAL SPECIMENS',
                style: GoogleFonts.inter(
                  color: Colors.white54,
                  fontSize: 8.sp,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (entries.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: kTeal,
                border: Border.all(color: Colors.black54, width: 1.5),
                boxShadow: const [
                  BoxShadow(color: Colors.black87, offset: Offset(2, 2)),
                ],
              ),
              child: Text(
                '${_currentIndex + 1} / ${entries.length}',
                style: GoogleFonts.firaCode(
                  color: kSmokedPaper,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          SizedBox(width: 12.w),
          _buildScrew(),
        ],
      ),
    );
  }

  // The 3D Pressure Plate with Deformation Shader
  Widget _buildHighPolyPressurePlate(BuildContext context, StrainGaugeModel entry,
      ImageNotifier imageProv, int index, double pageOffset) {
    
    // Vertical Tension Logic (Extensometer Effect)
    // Elongate or compress based on scroll velocity
    double stretch = 1.0 + (_velocity.abs() * 0.015).clamp(0.0, 0.25);
    double compress = 1.0 - (_velocity.abs() * 0.005).clamp(0.0, 0.1);
    double skewX = (_velocity * 0.0005).clamp(-0.05, 0.05);

    // Parallax logic based on scroll position in the PageView
    double depthScale = 1.0 - (pageOffset.abs() * 0.15).clamp(0.0, 0.5);
    double rotateX = pageOffset * 0.5;

    return Center(
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002) // Severe 3D perspective
          ..multiply(Matrix4.diagonal3Values(compress * depthScale, stretch * depthScale, 1.0))
          ..rotateX(-rotateX)
          ..rotateZ(skewX),
        child: GestureDetector(
          onTap: () {
            final mainIndex = ref.read(projectProvider).entries.indexOf(entry);
            Navigator.pushNamed(context, '/info_screen', arguments: {'index': mainIndex});
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: kSmokedPaper,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: Colors.black87, width: 2),
              // Extreme 3D Workbench dropshadows
              boxShadow: const [
                BoxShadow(color: Colors.black87, offset: Offset(20, 20), blurRadius: 25, spreadRadius: -5),
                BoxShadow(color: Colors.black54, offset: Offset(10, 10), blurRadius: 10),
              ],
            ),
            child: Stack(
              children: [
                // Gyro-reactive Mechanical Diagram (Gears)
                Positioned(
                  right: -80.w,
                  bottom: -50.h,
                  child: Transform.rotate(
                    angle: _gyroRotation,
                    child: Icon(Icons.settings, size: 280.sp, color: kTeal.withValues(alpha: 0.08)),
                  ),
                ),
                Positioned(
                  left: -40.w,
                  top: 100.h,
                  child: Transform.rotate(
                    angle: -_gyroRotation * 1.5,
                    child: Icon(Icons.settings, size: 150.sp, color: kBrass.withValues(alpha: 0.12)),
                  ),
                ),
                
                // Content Layout
                Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildPhotoPlate(entry, imageProv),
                      SizedBox(height: 24.h),
                      _buildEngravedDataPlate(entry),
                    ],
                  ),
                ),
                
                // Four corner screws on the main board
                Positioned(top: 8.h, left: 8.w, child: _buildScrew(small: true)),
                Positioned(top: 8.h, right: 8.w, child: _buildScrew(small: true)),
                Positioned(bottom: 8.h, left: 8.w, child: _buildScrew(small: true)),
                Positioned(bottom: 8.h, right: 8.w, child: _buildScrew(small: true)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPlate(StrainGaugeModel entry, ImageNotifier imageProv) {
    final imagePath = imageProv.getImagePath(entry.photoPath);
    return Expanded(
      flex: 5,
      child: Container(
        decoration: BoxDecoration(
          color: kHammerDark,
          border: Border(
            top: const BorderSide(color: Colors.black87, width: 3),
            left: const BorderSide(color: Colors.black87, width: 3),
            bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 1),
            right: BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 1),
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(4, 4)) // Simulated inner shadow effect below via border
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: Container(
            color: Colors.black,
            child: (entry.photoPath.isNotEmpty && imagePath != null && File(imagePath).existsSync())
                ? Image.file(File(imagePath), fit: BoxFit.cover)
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.precision_manufacturing, color: kBrassLight.withValues(alpha: 0.4), size: 56.sp),
                        SizedBox(height: 12.h),
                        Text('FILE MISSING', style: GoogleFonts.specialElite(color: kBrassLight.withValues(alpha: 0.4), fontSize: 10.sp, letterSpacing: 2.0)),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildEngravedDataPlate(StrainGaugeModel entry) {
    return Expanded(
      flex: 3,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: const BoxDecoration(
          color: kTeal,
          border: Border(
            top: BorderSide(color: Colors.white30, width: 2),
            left: BorderSide(color: Colors.white30, width: 2),
            bottom: BorderSide(color: Colors.black87, width: 3),
            right: BorderSide(color: Colors.black87, width: 3),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black38, offset: Offset(4, 4), blurRadius: 6),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildEngravedText('SPECIMEN ID: ${entry.testIdentifier.toUpperCase()}', 10.sp, isLabel: true),
                SizedBox(height: 4.h),
                _buildEngravedText(entry.instrumentName.toUpperCase(), 18.sp, maxLines: 2),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildEngravedText(entry.instrumentType.label.toUpperCase(), 10.sp, isLabel: true),
                    _buildEngravedText(entry.conditionState.label.toUpperCase(), 10.sp, isLabel: true, color: kBrassLight),
                  ],
                ),
              ],
            ),
            // Screws on the nameplate
            Positioned(top: 0, left: 0, child: _buildScrew(small: true)),
            Positioned(top: 0, right: 0, child: _buildScrew(small: true)),
            Positioned(bottom: 0, left: 0, child: _buildScrew(small: true)),
            Positioned(bottom: 0, right: 0, child: _buildScrew(small: true)),
          ],
        ),
      ),
    );
  }

  Widget _buildEngravedText(String text, double size, {bool isLabel = false, int maxLines = 1, Color? color}) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.firaCode(
        color: color ?? (isLabel ? kSmokedPaper.withValues(alpha: 0.7) : kBrass),
        fontSize: size,
        fontWeight: isLabel ? FontWeight.w500 : FontWeight.w800,
        height: 1.2,
        shadows: [
          const Shadow(color: Colors.black87, offset: Offset(1, 1), blurRadius: 1), // Engraved deep shadow
          const Shadow(color: Colors.white24, offset: Offset(-0.5, -0.5), blurRadius: 0), // Subtle highlight edge
        ],
      ),
    );
  }

  Widget _buildScrew({bool small = false}) {
    final size = small ? 8.w : 14.w;
    final randAngle = _random.nextDouble() * 3.14;
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF555555), Color(0xFF222222)],
        ),
        boxShadow: [
          BoxShadow(color: Colors.black87, offset: Offset(1, 1), blurRadius: 2),
          BoxShadow(color: Colors.white24, offset: Offset(-1, -1), blurRadius: 1),
        ],
      ),
      child: Center(
        child: Transform.rotate(
          angle: randAngle,
          child: Container(
            width: size * 0.7,
            height: size * 0.15,
            decoration: const BoxDecoration(
              color: Colors.black87,
              boxShadow: [
                BoxShadow(color: Colors.white24, offset: Offset(0, 0.5), blurRadius: 0) // Slot highlight
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: kTeal,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black87, width: 4),
              boxShadow: const [
                BoxShadow(color: Colors.black87, offset: Offset(6, 6), blurRadius: 12),
              ]
            ),
            child: Icon(Icons.warning_amber_rounded, size: 48.sp, color: kBrass),
          ),
          SizedBox(height: 24.h),
          Text(
            'VAULT EMPTY',
            style: GoogleFonts.specialElite(
              color: kBrass,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 4.0,
              shadows: const [Shadow(color: Colors.black87, offset: Offset(2, 2), blurRadius: 4)]
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'NO SPECIMENS DETECTED ON BENCH',
            style: GoogleFonts.firaCode(
              color: Colors.white54,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}

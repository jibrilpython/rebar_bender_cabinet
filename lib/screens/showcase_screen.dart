import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebar_bender_cabinet/models/rebar_tool_model.dart';
import 'package:rebar_bender_cabinet/providers/project_provider.dart';
import 'package:rebar_bender_cabinet/screens/info_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Scanner Theme Colors
// ─────────────────────────────────────────────────────────────────────────────
const Color kSpaceBlack = Color(0xFF07090D);
const Color kTerminalGreen = Color(0xFF10B981);
const Color kScannerOrange = Color(0xFFF97316);
const Color kGridLine = Color(0xFF1E293B);

class ShowcaseScreen extends ConsumerStatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  ConsumerState<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends ConsumerState<ShowcaseScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  Offset _lensPosition = const Offset(200, 300);
  final double _lensRadius = 80.0;

  bool _isSelectingTarget = false;

  // Terminal typing animation logic
  late AnimationController _typewriterCtrl;
  late Animation<int> _typewriterAnim;
  String _terminalText = '';

  @override
  void initState() {
    super.initState();
    _typewriterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _typewriterCtrl.dispose();
    super.dispose();
  }

  void _loadTerminalData(RebarToolModel item) {
    setState(() {
      _terminalText =
          '''
> INITIALIZING SCAN...
> TARGET LOCK: ${item.toolType?.name.toUpperCase() ?? 'UNKNOWN'}
> SYS-ID: ${item.catalogueIdentifier ?? 'N/A'}
> MFG: ${item.manufacturer ?? 'UNKNOWN'}
> ERA: ${item.eraOfProduction ?? 'UNKNOWN'}
> CLASSIFICATION: ${item.toolName ?? 'PROTOTYPE'}

REBAR SCANNER ACTIVE. DRAG LENS TO INSPECT INTERNAL STRUCTURAL INTEGRITY.
''';
    });

    _typewriterAnim = IntTween(
      begin: 0,
      end: _terminalText.length,
    ).animate(CurvedAnimation(parent: _typewriterCtrl, curve: Curves.linear));

    _typewriterCtrl.forward(from: 0.0);
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(projectProvider).allItems;

    if (items.isEmpty) {
      return const Scaffold(
        backgroundColor: kSpaceBlack,
        body: Center(
          child: Text('ARCHIVE EMPTY', style: TextStyle(color: kTerminalGreen)),
        ),
      );
    }

    if (_currentIndex >= items.length) {
      _currentIndex = 0;
    }

    final currentTarget = items[_currentIndex];

    // Ensure terminal text is loaded for the very first build
    if (_terminalText.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadTerminalData(currentTarget);
      });
    }

    return Scaffold(
      backgroundColor: kSpaceBlack,
      body: Stack(
        children: [
          // ── Background Grid ──────────────────────────────────────────────
          Positioned.fill(child: CustomPaint(painter: _RadarGridPainter())),

          // ── The Central Object Base Layer (Normal visibility) ────────────
          Center(
            child: Container(
              width: 250.r,
              height: 250.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(200), blurRadius: 50),
                ],
              ),
              child: ClipOval(
                child: currentTarget.imagePath != null
                    ? Image.file(
                        File(currentTarget.imagePath!),
                        fit: BoxFit.cover,
                        color: Colors.grey.withAlpha(150),
                        colorBlendMode: BlendMode
                            .modulate, // Dim the base image to look scientific
                      )
                    : Container(
                        color: const Color(0xFF111827),
                        child: Icon(
                          Icons.handyman_outlined,
                          size: 80.r,
                          color: kGridLine,
                        ),
                      ),
              ),
            ),
          ),

          // ── The X-Ray Lens Layer (Reveals wireframe ONLY under lens) ─────
          // We use ClipPath with the exact circle of the lens to overlay the CustomPaint.
          ClipPath(
            clipper: _LensClipper(position: _lensPosition, radius: _lensRadius),
            child: Stack(
              children: [
                // Glowing blue background just inside the lens window
                Container(color: const Color(0xFF0F172A).withAlpha(200)),
                // The actual X-Ray structural lines drawn only where clipped
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: CustomPaint(
                        size: Size(300.w, 400.h),
                        painter: _XRayWireframePainter(),
                      ),
                    ),
                    if (currentTarget.imagePath != null)
                      Center(
                        child: SizedBox(
                          width: 250.r,
                          height: 250.r,
                          child: ClipOval(
                            child: ColorFiltered(
                              // Invert colors to create a literal "X-Ray" Negative effect
                              colorFilter: const ColorFilter.matrix([
                                -1,
                                0,
                                0,
                                0,
                                255,
                                0,
                                -1,
                                0,
                                0,
                                255,
                                0,
                                0,
                                -1,
                                0,
                                255,
                                0,
                                0,
                                0,
                                1,
                                0,
                              ]),
                              child: ColorFiltered(
                                // Tint the inverted negative entirely with the scanner orange
                                colorFilter: const ColorFilter.mode(
                                  kScannerOrange,
                                  BlendMode.color, // Colorize the negative
                                ),
                                child: Image.file(
                                  File(currentTarget.imagePath!),
                                  fit: BoxFit.cover,
                                ),
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

          // ── The Physical Lens Ring Overlay ───────────────────────────────
          // This sits exactly over the lens boundary to draw the UI edges of the magnifying glass
          Positioned(
            left: _lensPosition.dx - _lensRadius,
            top: _lensPosition.dy - _lensRadius,
            child: IgnorePointer(
              // Let drags pass through to the gesture detector
              child: Container(
                width: _lensRadius * 2,
                height: _lensRadius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kScannerOrange, width: 2.0),
                  boxShadow: [
                    BoxShadow(
                      color: kScannerOrange.withAlpha(50),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  // Crosshairs inside the lens
                  child: Icon(
                    Icons.add,
                    color: kScannerOrange.withAlpha(150),
                    size: 30.r,
                  ),
                ),
              ),
            ),
          ),

          // ── The Gesture Canvas ───────────────────────────────────────────
          // Captures drags everywhere to move the lens
          Positioned.fill(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _lensPosition = details.localPosition;
                });
              },
            ),
          ),

          // ── The Terminal HUD (Bottom Left) ───────────────────────────────
          Positioned(
            left: 20.w,
            bottom: 20.h,
            right: 120.w, // Leave room for target button
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(180),
                border: const Border(
                  left: BorderSide(color: kTerminalGreen, width: 2.0),
                ),
              ),
              child: AnimatedBuilder(
                animation: _typewriterAnim,
                builder: (context, child) {
                  final currentText = _terminalText.substring(
                    0,
                    _typewriterAnim.value,
                  );
                  final isDone = _typewriterAnim.value == _terminalText.length;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentText + (isDone ? '' : ' █'),
                        style: GoogleFonts.firaCode(
                          fontSize: 10.sp,
                          color: kTerminalGreen,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      if (isDone) ...[
                        SizedBox(height: 12.h),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InfoScreen(item: currentTarget),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: kTerminalGreen.withAlpha(50),
                              border: Border.all(color: kTerminalGreen),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.terminal,
                                  color: kTerminalGreen,
                                  size: 14.r,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'ACCESS SCHEMATICS',
                                  style: GoogleFonts.firaCode(
                                    color: kTerminalGreen,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),

          // ── Target Lock Selection Overrides ──────────────────────────────
          Positioned(
            right: 20.w,
            bottom: 20.h,
            child: GestureDetector(
              onTap: () {
                setState(() => _isSelectingTarget = true);
                HapticFeedback.mediumImpact();
              },
              child: Container(
                width: 80.r,
                height: 80.r,
                decoration: BoxDecoration(
                  color: kSpaceBlack,
                  shape: BoxShape.circle,
                  border: Border.all(color: kScannerOrange, width: 2.0),
                  boxShadow: [
                    BoxShadow(
                      color: kScannerOrange.withAlpha(80),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.track_changes_outlined,
                      color: kScannerOrange,
                      size: 28.r,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'TARGET',
                      style: GoogleFonts.barlow(
                        fontSize: 10.sp,
                        color: kScannerOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── The Target Selection Overlay Map ─────────────────────────────
          if (_isSelectingTarget)
            Positioned.fill(
              child: Container(
                color: kSpaceBlack.withAlpha(240), // Darken background heavily
                child: SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SELECT ANALYSIS TARGET',
                              style: GoogleFonts.firaCode(
                                color: kScannerOrange,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: kScannerOrange,
                              ),
                              onPressed: () {
                                setState(() => _isSelectingTarget = false);
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10.w,
                                mainAxisSpacing: 10.h,
                              ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final target = items[index];
                            final isCurrent = index == _currentIndex;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentIndex = index;
                                  _isSelectingTarget = false;
                                });
                                _loadTerminalData(target);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isCurrent
                                        ? kScannerOrange
                                        : kGridLine,
                                    width: isCurrent ? 2.0 : 1.0,
                                  ),
                                ),
                                child: target.imagePath != null
                                    ? Image.file(
                                        File(target.imagePath!),
                                        fit: BoxFit.cover,
                                        color: isCurrent
                                            ? null
                                            : Colors.grey.withAlpha(100),
                                        colorBlendMode: isCurrent
                                            ? null
                                            : BlendMode.saturation,
                                      )
                                    : Center(
                                        child: Icon(
                                          Icons.handyman,
                                          color: isCurrent
                                              ? kScannerOrange
                                              : kGridLine,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  The X-Ray Structural Wireframe Painter
// ─────────────────────────────────────────────────────────────────────────────
class _XRayWireframePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // We draw an exact isometric rendering of a concrete column with rebar.
    // This looks like an architectural cad drawing.
    final cx = size.width / 2;
    final cy = size.height / 2;
    canvas.translate(cx, cy);

    final linePaint = Paint()
      ..color = kScannerOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final faintLine = Paint()
      ..color = kScannerOrange.withAlpha(80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final halfW = 80.0;
    final halfH = 150.0;

    // Draw external faint architectural bounds
    canvas.drawRect(Rect.fromLTRB(-halfW, -halfH, halfW, halfH), faintLine);

    // Draw thick internal rebar
    final inset = 20.0;
    // vertical bars
    canvas.drawLine(
      Offset(-halfW + inset, -halfH),
      Offset(-halfW + inset, halfH),
      linePaint,
    );
    canvas.drawLine(
      Offset(halfW - inset, -halfH),
      Offset(halfW - inset, halfH),
      linePaint,
    );

    // horizontal ties
    for (int i = 0; i < 7; i++) {
      double y = -halfH + 20 + (i * 40);
      canvas.drawLine(
        Offset(-halfW + inset, y),
        Offset(halfW - inset, y),
        linePaint,
      );

      // Draw small circles at intersections to look highly structural
      canvas.drawCircle(
        Offset(-halfW + inset, y),
        3.0,
        Paint()..color = kScannerOrange,
      );
      canvas.drawCircle(
        Offset(halfW - inset, y),
        3.0,
        Paint()..color = kScannerOrange,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
//  Lens Clipper (Cuts a hole in the top layer)
// ─────────────────────────────────────────────────────────────────────────────
class _LensClipper extends CustomClipper<Path> {
  final Offset position;
  final double radius;

  _LensClipper({required this.position, required this.radius});

  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromCircle(center: position, radius: radius));
  }

  @override
  bool shouldReclip(covariant _LensClipper oldClipper) {
    return position != oldClipper.position || radius != oldClipper.radius;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Radar Background Grid
// ─────────────────────────────────────────────────────────────────────────────
class _RadarGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kGridLine
      ..strokeWidth = 1.0;

    final step = 50.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Center cross
    final strongPaint = Paint()
      ..color = kGridLine.withAlpha(150)
      ..strokeWidth = 2.0;

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      strongPaint,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      strongPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

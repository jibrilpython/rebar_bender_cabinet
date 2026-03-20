import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strain_guage_box/common/photo_bottom_sheet.dart';
import 'package:strain_guage_box/enum/my_enums.dart';
import 'package:strain_guage_box/providers/image_provider.dart';
import 'package:strain_guage_box/providers/input_provider.dart';
import 'package:strain_guage_box/providers/project_provider.dart';
import 'package:strain_guage_box/utils/const.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── TACTILE ASSETS ──────────────────────────────────────────────────────────
const Color kBrass = Color(0xFF8B6B43);
const Color kBrassLight = Color(0xFFB08D57);

class AddScreen extends ConsumerStatefulWidget {
  final bool isEdit;
  final int currentIndex;

  const AddScreen({super.key, this.isEdit = false, this.currentIndex = 0});

  @override
  ConsumerState<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends ConsumerState<AddScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _gaugeAnim;
  
  final math.Random _random = math.Random(123);

  late TextEditingController _idCtrl;
  late TextEditingController _nameCtrl;
  late TextEditingController _manufacturerCtrl;
  late TextEditingController _modelCtrl;
  late TextEditingController _countryCtrl;
  late TextEditingController _yearCtrl;
  late TextEditingController _rangeCtrl;
  late TextEditingController _sensitivityCtrl;
  late TextEditingController _attachmentCtrl;
  late TextEditingController _materialsCtrl;
  late TextEditingController _dimensionsCtrl;
  late TextEditingController _accessoriesCtrl;
  late TextEditingController _provenanceCtrl;
  late TextEditingController _notesCtrl;
  late TextEditingController _tagsCtrl;

  @override
  void initState() {
    super.initState();
    _gaugeAnim = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 600)
    )..forward();

    final p = ref.read(inputProvider);
    _idCtrl = TextEditingController(text: p.testIdentifier);
    _nameCtrl = TextEditingController(text: p.instrumentName);
    _manufacturerCtrl = TextEditingController(text: p.manufacturer);
    _modelCtrl = TextEditingController(text: p.model);
    _countryCtrl = TextEditingController(text: p.countryOfManufacture);
    _yearCtrl = TextEditingController(text: p.yearOfManufacture == 1950 ? '' : p.yearOfManufacture.toString());
    _rangeCtrl = TextEditingController(text: p.measurementRange);
    _sensitivityCtrl = TextEditingController(text: p.sensitivityAccuracy);
    _attachmentCtrl = TextEditingController(text: p.attachmentMethod);
    _materialsCtrl = TextEditingController(text: p.materials);
    _dimensionsCtrl = TextEditingController(text: p.dimensions);
    _accessoriesCtrl = TextEditingController(text: p.accessories);
    _provenanceCtrl = TextEditingController(text: p.provenance);
    _notesCtrl = TextEditingController(text: p.notes);
    _tagsCtrl = TextEditingController(text: p.tags.join(', '));
  }

  @override
  void dispose() {
    _gaugeAnim.dispose();
    for (final c in [_idCtrl, _nameCtrl, _manufacturerCtrl, _modelCtrl, _countryCtrl, _yearCtrl, _rangeCtrl, _sensitivityCtrl, _attachmentCtrl, _materialsCtrl, _dimensionsCtrl, _accessoriesCtrl, _provenanceCtrl, _notesCtrl, _tagsCtrl]) { c.dispose(); }
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic);
      setState(() => _currentPage++);
    }
  }
  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic);
      setState(() => _currentPage--);
    }
  }

  void _save() async {
    showDialog(context: context, barrierDismissible: false, builder: (_) => const _SavingDialog());
    await Future.delayed(const Duration(milliseconds: 1500));
    if (widget.isEdit) { ref.read(projectProvider).editEntry(ref, widget.currentIndex); }
    else { ref.read(projectProvider).addEntry(ref); }
    if (mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
      ref.read(inputProvider).clearAll();
      ref.read(imageProvider).clearImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = ['IDENTITY', 'TECHNICAL', 'CONDITION', 'RECORDS'];
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildTactileHeader(steps),
            _buildIndustrialGauge(steps.length),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPage1(),
                  _buildPage2(),
                  _buildPage3(),
                  _buildPage4(),
                ],
              ),
            ),
            _buildStampedBottomNav(),
          ],
        ),
      ),
    );
  }

  // ── HEADER ─────────────────────────────────────────────────────────────────
  Widget _buildTactileHeader(List<String> steps) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      child: Row(
        children: [
          _buildMachinedCircleBtn(
            icon: Icons.close_rounded,
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          // Engraved Metal Plate Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: kBackground,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: const [
                BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(2, 2), blurRadius: 4),
                BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-2, -2), blurRadius: 4),
              ],
            ),
            child: Column(
              children: [
                Text(
                  widget.isEdit ? 'AMEND RECORD' : 'NEW REGISTRY',
                  style: GoogleFonts.specialElite(
                    color: kAccent.withValues(alpha: 0.6), 
                    fontSize: 8.sp, 
                    fontWeight: FontWeight.w700, 
                    letterSpacing: 2.0
                  ),
                ),
                Text(
                  steps[_currentPage],
                  style: GoogleFonts.inter(
                    color: kPrimaryText, 
                    fontSize: 16.sp, 
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(width: 44.w), // Balance
        ],
      ),
    );
  }

  // ── INDUSTRIAL GAUGE (Step Indicator) ──────────────────────────────────────
  Widget _buildIndustrialGauge(int totalSteps) {
    return Container(
      height: 54.h,
      margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The Track
          Container(
            height: 4.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kBackground,
              borderRadius: BorderRadius.circular(kRadiusPill),
              boxShadow: const [
                BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(1, 1), blurRadius: 2),
                BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-1, -1), blurRadius: 2),
              ],
            ),
          ),
          // Measuring Ticks
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(20, (i) => Container(
              height: i % 5 == 0 ? 12.h : 6.h,
              width: 1.5.w,
              color: kSecondaryText.withValues(alpha: 0.2),
            )),
          ),
          // The Needle / Slider
          AnimatedAlign(
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            alignment: Alignment(-1.0 + (_currentPage / (totalSteps - 1) * 2), 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_drop_down_rounded, color: kAccent, size: 24.sp),
                Container(
                  width: 14.w,
                  height: 14.w,
                  decoration: BoxDecoration(
                    color: kAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                    boxShadow: [
                      BoxShadow(color: kAccent.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 4))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── PAGE 1: IDENTITY ───────────────────────────────────────────────────────
  Widget _buildPage1() {
    final p = ref.watch(inputProvider);
    return _scrollPage(children: [
      _pageLabel('PART 01 // CORE IDENTITY'),
      SizedBox(height: 18.h),
      _machinedField(
        label: 'INSTRUMENT DESIGNATION', 
        ctrl: _nameCtrl, 
        hint: 'e.g. Huggenberger Tensometer Type A', 
        onChanged: (v) => p.instrumentName = v,
        icon: Icons.label_important_outline,
      ),
      SizedBox(height: 16.h),
      _machinedField(
        label: 'CATALOGUE IDENTIFIER', 
        ctrl: _idCtrl, 
        hint: 'e.g. SGB-TEN-1950-047',
        onChanged: (v) => p.testIdentifier = v,
        icon: Icons.fingerprint_rounded,
      ),
      SizedBox(height: 24.h),
      _sectionHeader('CLASS SELECTION'),
      SizedBox(height: 12.h),
      _machinedTypeGrid(p),
      SizedBox(height: 24.h),
      Row(children: [
        Expanded(child: _machinedField(label: 'MANUFACTURER', ctrl: _manufacturerCtrl, hint: 'HUGGENBERGER', onChanged: (v) => p.manufacturer = v)),
        SizedBox(width: 12.w),
        Expanded(child: _machinedField(label: 'MODEL', ctrl: _modelCtrl, hint: 'TYPE A MK.II', onChanged: (v) => p.model = v)),
      ]),
    ]);
  }

  Widget _machinedTypeGrid(InputNotifier p) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: InstrumentType.values.map((t) {
        final isSel = p.instrumentType == t;
        return GestureDetector(
          onTap: () => p.instrumentType = t,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: kBackground,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: isSel
                  ? [
                      const BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(2, 2), blurRadius: 4),
                      const BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-2, -2), blurRadius: 4),
                    ]
                  : [
                      const BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(3, 3), blurRadius: 6),
                      const BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-3, -3), blurRadius: 6),
                    ],
              border: isSel ? Border.all(color: kAccent.withValues(alpha: 0.3), width: 1) : null,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Text(
                  t.label.toUpperCase(),
                  style: GoogleFonts.firaCode(
                    color: isSel ? kAccent : kSecondaryText,
                    fontSize: 9.sp,
                    fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
                if (isSel)
                  Positioned(
                    top: -6.h,
                    right: -10.w,
                    child: _buildScrew(small: true),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── PAGE 2: SPECS ──────────────────────────────────────────────────────────
  Widget _buildPage2() {
    final p = ref.watch(inputProvider);
    return _scrollPage(children: [
      _pageLabel('PART 02 // TECHNICAL SPECIFICATIONS'),
      SizedBox(height: 18.h),
      Row(children: [
        Expanded(child: _machinedField(
          label: 'YEAR', 
          ctrl: _yearCtrl, 
          hint: '1955',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
          onChanged: (v) => p.yearOfManufacture = int.tryParse(v) ?? 1950,
        )),
        SizedBox(width: 12.w),
        Expanded(child: _machinedField(label: 'ORIGIN', ctrl: _countryCtrl, hint: 'SWITZERLAND', onChanged: (v) => p.countryOfManufacture = v)),
      ]),
      SizedBox(height: 24.h),
      _sectionHeader('OPERATING PRINCIPLE'),
      SizedBox(height: 12.h),
      _tactileToggleGrid(p),
      SizedBox(height: 24.h),
      _machinedField(label: 'MEASUREMENT RANGE', ctrl: _rangeCtrl, hint: '0–50 MM', onChanged: (v) => p.measurementRange = v, icon: Icons.straighten),
      SizedBox(height: 16.h),
      _machinedField(label: 'SENSITIVITY / ACCURACY', ctrl: _sensitivityCtrl, hint: '0.001 MM/DIV', onChanged: (v) => p.sensitivityAccuracy = v, icon: Icons.shutter_speed),
      SizedBox(height: 16.h),
      _machinedField(label: 'ATTACHMENT METHOD', ctrl: _attachmentCtrl, hint: 'MECHANICAL CLAMPS, ADHESIVE...', onChanged: (v) => p.attachmentMethod = v, icon: Icons.settings_input_component),
    ]);
  }

  Widget _tactileToggleGrid(InputNotifier p) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: OperatingPrinciple.values.map((pr) {
        final isSel = p.operatingPrinciple == pr;
        return GestureDetector(
          onTap: () => p.operatingPrinciple = pr,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSel ? kAccent : kBackground,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: isSel
                  ? [BoxShadow(color: kAccent.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))]
                  : [
                      const BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(3, 3), blurRadius: 6),
                      const BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-3, -3), blurRadius: 6),
                    ],
            ),
            child: Text(
              pr.label.toUpperCase(),
              style: GoogleFonts.firaCode(
                color: isSel ? Colors.white : kSecondaryText,
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── PAGE 3: CONDITION ──────────────────────────────────────────────────────
  Widget _buildPage3() {
    final p = ref.watch(inputProvider);
    return _scrollPage(children: [
      _pageLabel('PART 03 // CONDITION & PROVENANCE'),
      SizedBox(height: 18.h),
      _sectionHeader('CURRENT STATE'),
      SizedBox(height: 14.h),
      ...ConditionState.values.map((state) {
        final isSel = p.conditionState == state;
        final col = getConditionColor(state);
        return GestureDetector(
          onTap: () => p.conditionState = state,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: kBackground,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                if (isSel) 
                   const BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(2, 2), blurRadius: 4)
                else 
                   const BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(4, 4), blurRadius: 8),
                if (isSel)
                   const BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-2, -2), blurRadius: 4)
                else
                   const BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-4, -4), blurRadius: 8),
              ],
            ),
            child: Row(
              children: [
                _buildScrew(color: isSel ? col : kSecondaryText.withValues(alpha: 0.3)),
                SizedBox(width: 14.w),
                Text(state.label.toUpperCase(), 
                   style: GoogleFonts.inter(
                     color: isSel ? col : kSecondaryText, 
                     fontSize: 12.sp, 
                     fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                     letterSpacing: 0.5
                   )),
                const Spacer(),
                if (isSel) Icon(Icons.radio_button_checked_rounded, color: col, size: 18.sp)
                else Icon(Icons.radio_button_off_rounded, color: kSecondaryText.withValues(alpha: 0.2), size: 18.sp),
              ],
            ),
          ),
        );
      }),
      SizedBox(height: 12.h),
      _machinedCertToggle(p),
      SizedBox(height: 24.h),
      _machinedField(label: 'MATERIALS', ctrl: _materialsCtrl, hint: 'BRASS, MACHINED STEEL, GLASS', maxLines: 2, onChanged: (v) => p.materials = v),
      SizedBox(height: 16.h),
      _machinedField(label: 'DIMENSIONS / WEIGHT', ctrl: _dimensionsCtrl, hint: '140×80 MM, 450G', onChanged: (v) => p.dimensions = v),
      SizedBox(height: 16.h),
      _machinedField(label: 'PROVENANCE', ctrl: _provenanceCtrl, hint: 'FACTORY CALIBRATION LAB...', maxLines: 3, onChanged: (v) => p.provenance = v),
    ]);
  }

  Widget _machinedCertToggle(InputNotifier p) {
    return GestureDetector(
      onTap: () => p.hasCalibrationCert = !p.hasCalibrationCert,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: const [
            BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(4, 4), blurRadius: 8),
            BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-4, -4), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('VERIFICATION STATUS', style: GoogleFonts.specialElite(color: kSecondaryText, fontSize: 8.sp, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                Text(p.hasCalibrationCert ? 'CERTIFICATE PRESENT' : 'CERTIFICATE ABSENT',
                  style: GoogleFonts.inter(color: p.hasCalibrationCert ? kSuccess : kError.withValues(alpha: 0.6), fontSize: 13.sp, fontWeight: FontWeight.w800)),
              ],
            ),
            const Spacer(),
            // Tactile Switch
            Container(
              width: 44.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: p.hasCalibrationCert ? kSuccess.withValues(alpha: 0.2) : kBackground,
                borderRadius: BorderRadius.circular(kRadiusPill),
                boxShadow: const [
                  BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(1, 1), blurRadius: 2),
                  BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-1, -1), blurRadius: 2),
                ],
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: p.hasCalibrationCert ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.all(2.r),
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: p.hasCalibrationCert ? kSuccess : kSecondaryText.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(1, 1))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── PAGE 4: RECORDS ────────────────────────────────────────────────────────
  Widget _buildPage4() {
    final p = ref.watch(inputProvider);
    final imageProv = ref.watch(imageProvider);
    final displayPath = imageProv.getImagePath(imageProv.resultImage);

    return _scrollPage(children: [
      _pageLabel('PART 04 // VISUAL RECORDS & NOTES'),
      SizedBox(height: 18.h),
      _sectionHeader('PHOTOGRAPHIC DOCUMENTATION'),
      SizedBox(height: 16.h),
      GestureDetector(
        onTap: () => photoBottomSheet(context, ref.read(imageProvider), 0, ref),
        child: Container(
          height: 240.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: kBackground,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: const [
              BoxShadow(
                  color: Color(0xFFA3B1C6), offset: Offset(6, 6), blurRadius: 12),
              BoxShadow(
                  color: Color(0xFFFFFFFF), offset: Offset(-6, -6), blurRadius: 12),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Container(
              decoration: BoxDecoration(
                color: kBackground,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0xFFA3B1C6), offset: Offset(2, 2), blurRadius: 4),
                  BoxShadow(
                      color: Color(0xFFFFFFFF), offset: Offset(-2, -2), blurRadius: 4),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: displayPath != null && File(displayPath).existsSync()
                    ? Image.file(File(displayPath), fit: BoxFit.cover)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined,
                              color: kAccent.withValues(alpha: 0.3), size: 32.sp),
                          SizedBox(height: 12.h),
                          Text('INITIALIZE CAMERA',
                              style: GoogleFonts.firaCode(
                                  color: kAccent.withValues(alpha: 0.4),
                                  fontSize: 10.sp,
                                  letterSpacing: 1.0)),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 24.h),
      _machinedField(label: 'ARCHIVAL NOTES', ctrl: _notesCtrl, hint: 'HISTORY, MARKINGS, OBSERVATIONS...', maxLines: 4, onChanged: (v) => p.notes = v),
      SizedBox(height: 16.h),
      _machinedField(
        label: 'TAGS (COMMA SEPARATED)', 
        ctrl: _tagsCtrl, 
        hint: 'BLUEPRINT, VINTAGE, SWISS...', 
        onChanged: (v) => p.tags = v.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      ),
    ]);
  }

  // ── SHARED MACHINED COMPONENTS ─────────────────────────────────────────────
  Widget _scrollPage({required List<Widget> children}) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 40.h),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _pageLabel(String text) {
    return Text(text, style: GoogleFonts.specialElite(color: kAccent, fontSize: 10.sp, fontWeight: FontWeight.w700, letterSpacing: 2.0));
  }

  Widget _sectionHeader(String label) {
    return Row(
      children: [
        Text(label, style: GoogleFonts.inter(color: kSecondaryText, fontSize: 9.sp, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
        SizedBox(width: 12.w),
        Expanded(child: Container(height: 1, color: kSecondaryText.withValues(alpha: 0.1))),
      ],
    );
  }

  Widget _machinedField({
    required String label,
    required TextEditingController ctrl,
    required Function(String) onChanged,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffix,
    IconData? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kBackground,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: const [
          BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(2, 2), blurRadius: 4),
          BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-2, -2), blurRadius: 4),
        ],
      ),
      child: TextField(
        controller: ctrl,
        onChanged: onChanged,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: GoogleFonts.firaCode(color: kPrimaryText, fontSize: 14.sp, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(color: kSecondaryText.withValues(alpha: 0.5), fontSize: 9.sp, fontWeight: FontWeight.w700, letterSpacing: 1.0),
          floatingLabelStyle: GoogleFonts.inter(color: kAccent, fontSize: 10.sp, fontWeight: FontWeight.w800, letterSpacing: 1.0),
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon, color: kSecondaryText.withValues(alpha: 0.3), size: 18.sp) : null,
          suffixIcon: suffix,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildMachinedCircleBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: const BoxDecoration(
          color: kBackground,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(4, 4), blurRadius: 8),
            BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-4, -4), blurRadius: 8),
          ],
        ),
        child: Center(child: Icon(icon, color: kSecondaryText, size: 20.sp)),
      ),
    );
  }



  Widget _buildScrew({Color? color, bool small = false}) {
    final size = small ? 10.w : 14.w;
    final randAngle = _random.nextDouble() * 3.14;
    final screwColor = color ?? kSecondaryText.withValues(alpha: 0.2);
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
        child: Transform.rotate(
          angle: randAngle,
          child: Container(
            width: size * 0.7,
            height: 1.5.h,
            color: screwColor,
          ),
        ),
      ),
    );
  }

  Widget _buildStampedBottomNav() {
    final isValid = _currentPage == 0
        ? ref.read(inputProvider).instrumentName.isNotEmpty && ref.read(inputProvider).manufacturer.isNotEmpty
        : true;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
      decoration: BoxDecoration(
        color: kBackground,
        border: Border(top: BorderSide(color: kSecondaryText.withValues(alpha: 0.1), width: 1)),
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            _buildMachinedCircleBtn(icon: Icons.arrow_back_rounded, onTap: _prevPage),
          if (_currentPage > 0) SizedBox(width: 16.w),
          Expanded(
            child: GestureDetector(
              onTap: isValid ? (_currentPage == 3 ? _save : _nextPage) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 56.h,
                decoration: BoxDecoration(
                  color: isValid ? kAccent : kBackground,
                  borderRadius: BorderRadius.circular(kRadiusMedium),
                  boxShadow: isValid
                      ? [BoxShadow(color: kAccent.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 6))]
                      : const [
                          BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(2, 2), blurRadius: 4),
                          BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-2, -2), blurRadius: 4),
                        ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPage == 3 ? 'FINALIZE RECORD' : 'PROCEED',
                        style: GoogleFonts.specialElite(
                          color: isValid ? Colors.white : kSecondaryText.withValues(alpha: 0.3), 
                          fontSize: 14.sp, 
                          fontWeight: FontWeight.w700, 
                          letterSpacing: 2.0
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        _currentPage == 3 ? Icons.fact_check_rounded : Icons.double_arrow_rounded,
                        color: isValid ? Colors.white : kSecondaryText.withValues(alpha: 0.3), 
                        size: 20.sp
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── SAVING DIALOG ─────────────────────────────────────────────────────────────
class _SavingDialog extends StatefulWidget {
  const _SavingDialog();
  @override
  State<_SavingDialog> createState() => _SavingDialogState();
}

class _SavingDialogState extends State<_SavingDialog> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(40.r),
        decoration: BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(color: Color(0xFFA3B1C6), offset: Offset(10, 10), blurRadius: 20),
            BoxShadow(color: Color(0xFFFFFFFF), offset: Offset(-10, -10), blurRadius: 20),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(turns: _ctrl, child: Icon(Icons.architecture_rounded, color: kAccent, size: 48.sp)),
            SizedBox(height: 24.h),
            Text('ENGRAVING RECORD...', 
              style: GoogleFonts.specialElite(color: kAccent, fontSize: 13.sp, fontWeight: FontWeight.w700, letterSpacing: 2.0)),
            SizedBox(height: 8.h),
            Text('Processing metadata database', 
              style: GoogleFonts.inter(color: kSecondaryText, fontSize: 11.sp, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

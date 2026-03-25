import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebar_bender_cabinet/common/photo_bottom_sheet.dart';
import 'package:rebar_bender_cabinet/enum/my_enums.dart';
import 'package:rebar_bender_cabinet/providers/image_provider.dart';
import 'package:rebar_bender_cabinet/providers/input_provider.dart';
import 'package:rebar_bender_cabinet/providers/project_provider.dart';
import 'package:rebar_bender_cabinet/utils/const.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Add / Edit Screen — 3-page form
// ─────────────────────────────────────────────────────────────────────────────

class AddScreen extends ConsumerStatefulWidget {
  final bool isEdit;
  const AddScreen({super.key, required this.isEdit});

  @override
  ConsumerState<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends ConsumerState<AddScreen> {
  final _pageCtrl = PageController();
  int _currentPage = 0;
  static const _totalPages = 3;

  // Controllers
  final _catIdCtrl = TextEditingController();
  final _toolNameCtrl = TextEditingController();
  final _mfrCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _eraCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _serialCtrl = TextEditingController();
  final _rebarCapCtrl = TextEditingController();
  final _bendAngleCtrl = TextEditingController();
  final _materialCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _provenanceCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _tagsCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final inp = ref.read(inputProvider);
      _catIdCtrl.text = inp.catalogueIdentifier;
      _toolNameCtrl.text = inp.toolName;
      _mfrCtrl.text = inp.manufacturer;
      _countryCtrl.text = inp.countryOfOrigin;
      _eraCtrl.text = inp.eraOfProduction;
      _modelCtrl.text = inp.modelNumber;
      _serialCtrl.text = inp.serialNumber;
      _rebarCapCtrl.text = inp.rebarSizeCapacity;
      _bendAngleCtrl.text = inp.bendAngleRange;
      _materialCtrl.text = inp.material;
      _weightCtrl.text = inp.weight;
      _provenanceCtrl.text = inp.provenance;
      _notesCtrl.text = inp.notes;
      _tagsCtrl.text = inp.tags;
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    for (final c in [
      _catIdCtrl,
      _toolNameCtrl,
      _mfrCtrl,
      _countryCtrl,
      _eraCtrl,
      _modelCtrl,
      _serialCtrl,
      _rebarCapCtrl,
      _bendAngleCtrl,
      _materialCtrl,
      _weightCtrl,
      _provenanceCtrl,
      _notesCtrl,
      _tagsCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _next() {
    if (_currentPage < _totalPages - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submit();
    }
  }

  void _back() {
    if (_currentPage > 0) {
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _sync() {
    final inp = ref.read(inputProvider);
    inp.catalogueIdentifier = _catIdCtrl.text;
    inp.toolName = _toolNameCtrl.text;
    inp.manufacturer = _mfrCtrl.text;
    inp.countryOfOrigin = _countryCtrl.text;
    inp.eraOfProduction = _eraCtrl.text;
    inp.modelNumber = _modelCtrl.text;
    inp.serialNumber = _serialCtrl.text;
    inp.rebarSizeCapacity = _rebarCapCtrl.text;
    inp.bendAngleRange = _bendAngleCtrl.text;
    inp.material = _materialCtrl.text;
    inp.weight = _weightCtrl.text;
    inp.provenance = _provenanceCtrl.text;
    inp.notes = _notesCtrl.text;
    inp.tags = _tagsCtrl.text;
  }

  Future<void> _submit() async {
    _sync();
    final project = ref.read(projectProvider);
    if (widget.isEdit) {
      await project.editItem(ref);
    } else {
      await project.addItem(ref);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final inp = ref.watch(inputProvider);
    final img = ref.watch(imageProvider);

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _progress(),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [_page1(inp, img), _page2(inp), _page3()],
              ),
            ),
            _navBar(),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _header() {
    const labels = ['Identity', 'Provenance', 'Specs & Notes'];
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: _back,
            child: Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: kPanelBg,
                borderRadius: BorderRadius.circular(kRadiusStandard),
                border: Border.all(color: kOutline, width: kStrokeWeightThin),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: kSecondaryText,
                size: 19.r,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEdit ? 'EDIT TOOL' : 'NEW TOOL',
                  style: GoogleFonts.barlow(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: kAccent,
                    letterSpacing: 2.5,
                  ),
                ),
                Text(
                  labels[_currentPage],
                  style: GoogleFonts.barlow(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: kPrimaryText,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${_currentPage + 1} / $_totalPages',
            style: GoogleFonts.barlow(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: kMutedText,
            ),
          ),
        ],
      ),
    );
  }

  // ── Progress Bar ────────────────────────────────────────────────────────────
  Widget _progress() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: List.generate(_totalPages, (i) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < _totalPages - 1 ? 6.w : 0),
              height: 3.h,
              decoration: BoxDecoration(
                color: i <= _currentPage ? kAccent : kRaisedBg,
                borderRadius: BorderRadius.circular(kRadiusPill),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Page 1: Identity ────────────────────────────────────────────────────────
  Widget _page1(InputNotifier inp, ImageNotifier img) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _photoSection(img),
          SizedBox(height: 20.h),
          _sectionLabel('IDENTIFICATION'),
          SizedBox(height: 12.h),
          _field(
            _catIdCtrl,
            'Catalogue Identifier',
            'e.g. RBA-001',
            Icons.tag_rounded,
            onChanged: inp.setCatalogueIdentifier,
          ),
          SizedBox(height: 12.h),
          _field(
            _toolNameCtrl,
            'Tool Name',
            'e.g. Baileigh RB-800',
            Icons.label_outline_rounded,
            onChanged: inp.setToolName,
          ),
          SizedBox(height: 20.h),
          _sectionLabel('CLASSIFICATION'),
          SizedBox(height: 12.h),
          _chipSelector<ToolType>(
            label: 'Tool Type',
            values: ToolType.values,
            current: inp.toolType,
            getName: (e) => e.displayName,
            onChanged: ref.read(inputProvider).setToolType,
          ),
          SizedBox(height: 12.h),
          _chipSelector<OperationMethod>(
            label: 'Operation Method',
            values: OperationMethod.values,
            current: inp.operationMethod,
            getName: (e) => e.displayName,
            onChanged: ref.read(inputProvider).setOperationMethod,
          ),
          SizedBox(height: 12.h),
          _conditionSelector(inp),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  // ── Page 2: Provenance ──────────────────────────────────────────────────────
  Widget _page2(InputNotifier inp) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('MANUFACTURER & ORIGIN'),
          SizedBox(height: 12.h),
          _field(
            _mfrCtrl,
            'Manufacturer',
            'e.g. Baileigh Industrial',
            Icons.factory_outlined,
          ),
          SizedBox(height: 12.h),
          _field(
            _countryCtrl,
            'Country of Origin',
            'e.g. United States',
            Icons.flag_outlined,
          ),
          SizedBox(height: 12.h),
          _field(
            _eraCtrl,
            'Era of Production',
            'e.g. 1970',
            Icons.history_rounded,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            onChanged: inp.setEraOfProduction,
          ),
          SizedBox(height: 20.h),
          _sectionLabel('SERIAL & MODEL'),
          SizedBox(height: 12.h),
          _field(
            _modelCtrl,
            'Model Number',
            'e.g. RB-800',
            Icons.numbers_rounded,
          ),
          SizedBox(height: 12.h),
          _field(
            _serialCtrl,
            'Serial Number',
            'e.g. SN-19741023',
            Icons.qr_code_rounded,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  // ── Page 3: Specs & Notes ───────────────────────────────────────────────────
  Widget _page3() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('TECHNICAL SPECS'),
          SizedBox(height: 12.h),
          _field(
            _rebarCapCtrl,
            'Rebar Size Capacity',
            'e.g. #3 – #8, 6mm – 25mm',
            Icons.straighten_rounded,
          ),
          SizedBox(height: 12.h),
          _field(
            _bendAngleCtrl,
            'Bend Angle Range',
            'e.g. 0° – 180°',
            Icons.rotate_left_rounded,
          ),
          SizedBox(height: 12.h),
          _field(
            _materialCtrl,
            'Primary Material',
            'e.g. Cast Iron, Steel',
            Icons.hardware_rounded,
          ),
          SizedBox(height: 12.h),
          _field(_weightCtrl, 'Weight', 'e.g. 45 kg', Icons.scale_rounded),
          SizedBox(height: 20.h),
          _sectionLabel('COLLECTOR NOTES'),
          SizedBox(height: 12.h),
          _field(
            _provenanceCtrl,
            'Provenance / Acquisition',
            'Where / how you acquired it',
            Icons.receipt_long_outlined,
          ),
          SizedBox(height: 12.h),
          _field(
            _notesCtrl,
            'Notes',
            'Any additional notes…',
            Icons.notes_rounded,
            maxLines: 3,
          ),
          SizedBox(height: 12.h),
          _field(
            _tagsCtrl,
            'Tags',
            'e.g. industrial, vintage, rare',
            Icons.local_offer_outlined,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  // ── Photo area ──────────────────────────────────────────────────────────────
  Widget _photoSection(ImageNotifier img) {
    return GestureDetector(
      onTap: () => showPhotoBottomSheet(context, ref),
      child: Container(
        width: double.infinity,
        height: 180.h,
        decoration: BoxDecoration(
          color: kPanelBg,
          borderRadius: BorderRadius.circular(kRadiusLarge),
          border: Border.all(
            color: img.resultImage != null ? kAccentOutline : kOutline,
            width: kStrokeWeightMedium,
          ),
        ),
        child: img.resultImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(kRadiusLarge - 2),
                child: Image.file(
                  File(img.resultImage!),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _photoPlaceholder(),
                ),
              )
            : _photoPlaceholder(),
      ),
    );
  }

  Widget _photoPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 52.r,
          height: 52.r,
          decoration: BoxDecoration(
            color: kAccentMuted,
            borderRadius: BorderRadius.circular(kRadiusLarge),
          ),
          child: Icon(Icons.add_a_photo_outlined, color: kAccent, size: 24.r),
        ),
        SizedBox(height: 12.h),
        Text(
          'Tap to add a photo',
          style: GoogleFonts.barlow(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: kSecondaryText,
          ),
        ),
      ],
    );
  }

  // ── Shared Widgets ──────────────────────────────────────────────────────────
  Widget _sectionLabel(String label) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 14.h,
          decoration: BoxDecoration(
            color: kAccent,
            borderRadius: BorderRadius.circular(kRadiusPill),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: GoogleFonts.barlow(
            fontSize: 10.sp,
            fontWeight: FontWeight.w800,
            color: kAccent,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label,
    String hint,
    IconData icon, {
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style: GoogleFonts.inter(fontSize: 14.sp, color: kPrimaryText),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18.r, color: kMutedText),
      ),
    );
  }

  Widget _chipSelector<T>({
    required String label,
    required List<T> values,
    required T current,
    required String Function(T) getName,
    required void Function(T) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 12.sp, color: kSecondaryText),
          ),
        ),
        SizedBox(
          height: 38.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: values.length,
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemBuilder: (_, i) {
              final v = values[i];
              final sel = v == current;
              return GestureDetector(
                onTap: () => onChanged(v),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: sel ? kAccentMuted : kPanelBg,
                    borderRadius: BorderRadius.circular(kRadiusPill),
                    border: Border.all(
                      color: sel ? kAccent : kOutline,
                      width: sel ? kStrokeWeightMedium : kStrokeWeightThin,
                    ),
                  ),
                  child: Text(
                    getName(v),
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                      color: sel ? kAccent : kSecondaryText,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _conditionSelector(InputNotifier inp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            'Condition',
            style: GoogleFonts.inter(fontSize: 12.sp, color: kSecondaryText),
          ),
        ),
        SizedBox(
          height: 38.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: ConditionState.values.length,
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemBuilder: (_, i) {
              final v = ConditionState.values[i];
              final sel = v == inp.conditionState;
              final color = kConditionColors[v.name] ?? kSecondaryText;
              return GestureDetector(
                onTap: () => ref.read(inputProvider).setConditionState(v),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: sel ? color.withAlpha(40) : kPanelBg,
                    borderRadius: BorderRadius.circular(kRadiusPill),
                    border: Border.all(
                      color: sel ? color : kOutline,
                      width: sel ? kStrokeWeightMedium : kStrokeWeightThin,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        v.displayName,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                          color: sel ? color : kSecondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Bottom Nav ──────────────────────────────────────────────────────────────
  Widget _navBar() {
    final inp = ref.watch(inputProvider);
    final isLast = _currentPage == _totalPages - 1;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: kOutline, width: kStrokeWeightThin),
        ),
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            GestureDetector(
              onTap: _back,
              child: Container(
                width: 52.r,
                height: 52.r,
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                  color: kPanelBg,
                  borderRadius: BorderRadius.circular(kRadiusLarge),
                  border: Border.all(
                    color: kOutline,
                    width: kStrokeWeightMedium,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: kSecondaryText,
                  size: 20.r,
                ),
              ),
            ),
          Expanded(
            child: GestureDetector(
              onTap: inp.isBasicInfoValid ? _next : null,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: inp.isBasicInfoValid ? 1.0 : 0.4,
                child: Container(
                  height: 52.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [kAccentLight, kAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(kRadiusLarge),
                    boxShadow: inp.isBasicInfoValid ? kShadowAccent : [],
                  ),
                  child: Center(
                    child: Text(
                      isLast
                          ? (widget.isEdit ? 'SAVE CHANGES' : 'ADD TO ARCHIVE')
                          : 'CONTINUE',
                      style: GoogleFonts.barlow(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: kBackground,
                        letterSpacing: 1.0,
                      ),
                    ),
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebar_bender_cabinet/models/rebar_tool_model.dart';
import 'package:rebar_bender_cabinet/providers/image_provider.dart';
import 'package:rebar_bender_cabinet/providers/input_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Project Provider — CRUD for the rebar tool collection
// ─────────────────────────────────────────────────────────────────────────────

class ProjectNotifier extends ChangeNotifier {
  List<RebarToolModel> allItems = [];
  static const _key = 'rba_collection';

  final _uuid = const Uuid();

  // Currently being edited (for edit mode)
  RebarToolModel? _editingItem;

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      final List<dynamic> decoded = jsonDecode(raw);
      allItems = decoded
          .map((e) => RebarToolModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    notifyListeners();
  }

  // ── Save to storage ───────────────────────────────────────────────────────

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(allItems.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  // ── Add ──────────────────────────────────────────────────────────────────

  Future<void> addItem(WidgetRef ref) async {
    final input = ref.read(inputProvider);
    final img = ref.read(imageProvider);

    final item = RebarToolModel(
      id: _uuid.v4(),
      catalogueIdentifier: input.catalogueIdentifier.isEmpty
          ? null
          : input.catalogueIdentifier,
      toolName: input.toolName.isEmpty ? null : input.toolName,
      toolType: input.toolType,
      operationMethod: input.operationMethod,
      conditionState: input.conditionState,
      manufacturer: input.manufacturer.isEmpty ? null : input.manufacturer,
      countryOfOrigin:
          input.countryOfOrigin.isEmpty ? null : input.countryOfOrigin,
      eraOfProduction:
          input.eraOfProduction.isEmpty ? null : input.eraOfProduction,
      modelNumber: input.modelNumber.isEmpty ? null : input.modelNumber,
      serialNumber: input.serialNumber.isEmpty ? null : input.serialNumber,
      rebarSizeCapacity:
          input.rebarSizeCapacity.isEmpty ? null : input.rebarSizeCapacity,
      bendAngleRange:
          input.bendAngleRange.isEmpty ? null : input.bendAngleRange,
      material: input.material.isEmpty ? null : input.material,
      weight: input.weight.isEmpty ? null : input.weight,
      provenance: input.provenance.isEmpty ? null : input.provenance,
      notes: input.notes.isEmpty ? null : input.notes,
      tags: input.tags.isEmpty ? null : input.tags,
      imagePath: img.resultImage,
    );

    allItems.add(item);
    await _persist();

    ref.read(inputProvider).clearAll();
    ref.read(imageProvider).clearImage();

    notifyListeners();
  }

  // ── Load item into input provider (for editing) ───────────────────────────

  void loadItemIntoInput(RebarToolModel item, WidgetRef ref) {
    _editingItem = item;
    final input = ref.read(inputProvider);
    input.catalogueIdentifier = item.catalogueIdentifier ?? '';
    input.toolName = item.toolName ?? '';
    input.toolType = item.toolType ?? input.toolType;
    input.operationMethod = item.operationMethod ?? input.operationMethod;
    input.conditionState = item.conditionState ?? input.conditionState;
    input.manufacturer = item.manufacturer ?? '';
    input.countryOfOrigin = item.countryOfOrigin ?? '';
    input.eraOfProduction = item.eraOfProduction ?? '';
    input.modelNumber = item.modelNumber ?? '';
    input.serialNumber = item.serialNumber ?? '';
    input.rebarSizeCapacity = item.rebarSizeCapacity ?? '';
    input.bendAngleRange = item.bendAngleRange ?? '';
    input.material = item.material ?? '';
    input.weight = item.weight ?? '';
    input.provenance = item.provenance ?? '';
    input.notes = item.notes ?? '';
    input.tags = item.tags ?? '';

    if (item.imagePath != null) {
      ref.read(imageProvider).setImage(item.imagePath);
    }

    // trigger rebuild in consumers watching inputProvider
    input.notifyAll();
  }

  // ── Edit ─────────────────────────────────────────────────────────────────

  Future<void> editItem(WidgetRef ref) async {
    if (_editingItem == null) return;

    final input = ref.read(inputProvider);
    final img = ref.read(imageProvider);

    final updated = _editingItem!.copyWith(
      catalogueIdentifier: input.catalogueIdentifier.isEmpty
          ? null
          : input.catalogueIdentifier,
      toolName: input.toolName.isEmpty ? null : input.toolName,
      toolType: input.toolType,
      operationMethod: input.operationMethod,
      conditionState: input.conditionState,
      manufacturer: input.manufacturer.isEmpty ? null : input.manufacturer,
      countryOfOrigin:
          input.countryOfOrigin.isEmpty ? null : input.countryOfOrigin,
      eraOfProduction:
          input.eraOfProduction.isEmpty ? null : input.eraOfProduction,
      modelNumber: input.modelNumber.isEmpty ? null : input.modelNumber,
      serialNumber: input.serialNumber.isEmpty ? null : input.serialNumber,
      rebarSizeCapacity:
          input.rebarSizeCapacity.isEmpty ? null : input.rebarSizeCapacity,
      bendAngleRange:
          input.bendAngleRange.isEmpty ? null : input.bendAngleRange,
      material: input.material.isEmpty ? null : input.material,
      weight: input.weight.isEmpty ? null : input.weight,
      provenance: input.provenance.isEmpty ? null : input.provenance,
      notes: input.notes.isEmpty ? null : input.notes,
      tags: input.tags.isEmpty ? null : input.tags,
      imagePath: img.resultImage ?? _editingItem!.imagePath,
    );

    final idx = allItems.indexWhere((e) => e.id == _editingItem!.id);
    if (idx != -1) {
      allItems[idx] = updated;
    }

    await _persist();

    ref.read(inputProvider).clearAll();
    ref.read(imageProvider).clearImage();
    _editingItem = null;

    notifyListeners();
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<void> deleteItem(String id) async {
    allItems.removeWhere((e) => e.id == id);
    await _persist();
    notifyListeners();
  }
}

final projectProvider = ChangeNotifierProvider<ProjectNotifier>((ref) {
  return ProjectNotifier();
});

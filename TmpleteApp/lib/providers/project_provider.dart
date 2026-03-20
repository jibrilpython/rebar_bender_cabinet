import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:strain_guage_box/models/strain_gauge_model.dart';
import 'package:strain_guage_box/providers/image_provider.dart';
import 'package:strain_guage_box/providers/input_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ProjectNotifier extends ChangeNotifier {
  ProjectNotifier() {
    loadEntries();
  }

  List<StrainGaugeModel> entries = [];
  bool isLoading = true;
  static const String _storageKey = 'sgb_entries_v1';
  final _uuid = const Uuid();

  Future<void> loadEntries() async {
    isLoading = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        final List<dynamic> decodedList = jsonDecode(jsonString);
        entries = decodedList
            .map((item) => StrainGaugeModel.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading entries: $e');
      entries = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(
      entries.map((e) => e.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encodedList);
  }

  void addEntry(WidgetRef ref) {
    final p = ref.read(inputProvider);
    final imgProv = ref.read(imageProvider);

    entries.add(
      StrainGaugeModel(
        id: _uuid.v4(),
        testIdentifier: p.testIdentifier,
        instrumentName: p.instrumentName,
        instrumentType: p.instrumentType,
        manufacturer: p.manufacturer,
        model: p.model,
        countryOfManufacture: p.countryOfManufacture,
        yearOfManufacture: p.yearOfManufacture,
        operatingPrinciple: p.operatingPrinciple,
        measurementRange: p.measurementRange,
        sensitivityAccuracy: p.sensitivityAccuracy,
        attachmentMethod: p.attachmentMethod,
        materials: p.materials,
        dimensions: p.dimensions,
        conditionState: p.conditionState,
        accessories: p.accessories,
        hasCalibrationCert: p.hasCalibrationCert,
        provenance: p.provenance,
        notes: p.notes,
        photoPath: imgProv.resultImage.isNotEmpty
            ? imgProv.resultImage
            : p.photoPath,
        tags: List<String>.from(p.tags),
        dateAdded: p.dateAdded,
      ),
    );

    _save();
    notifyListeners();
  }

  void editEntry(WidgetRef ref, int index) {
    final p = ref.read(inputProvider);
    final imgProv = ref.read(imageProvider);
    final existing = entries[index];

    entries[index] = StrainGaugeModel(
      id: existing.id,
      testIdentifier: p.testIdentifier,
      instrumentName: p.instrumentName,
      instrumentType: p.instrumentType,
      manufacturer: p.manufacturer,
      model: p.model,
      countryOfManufacture: p.countryOfManufacture,
      yearOfManufacture: p.yearOfManufacture,
      operatingPrinciple: p.operatingPrinciple,
      measurementRange: p.measurementRange,
      sensitivityAccuracy: p.sensitivityAccuracy,
      attachmentMethod: p.attachmentMethod,
      materials: p.materials,
      dimensions: p.dimensions,
      conditionState: p.conditionState,
      accessories: p.accessories,
      hasCalibrationCert: p.hasCalibrationCert,
      provenance: p.provenance,
      notes: p.notes,
      photoPath: imgProv.resultImage.isNotEmpty
          ? imgProv.resultImage
          : existing.photoPath,
      tags: List<String>.from(p.tags),
      dateAdded: existing.dateAdded,
    );

    _save();
    notifyListeners();
  }

  void deleteEntry(int index) {
    entries.removeAt(index);
    _save();
    notifyListeners();
  }

  void fillInput(WidgetRef ref, int index) {
    final p = ref.read(inputProvider);
    final imgProv = ref.read(imageProvider);
    final entry = entries[index];

    p.testIdentifier = entry.testIdentifier;
    p.instrumentName = entry.instrumentName;
    p.instrumentType = entry.instrumentType;
    p.manufacturer = entry.manufacturer;
    p.model = entry.model;
    p.countryOfManufacture = entry.countryOfManufacture;
    p.yearOfManufacture = entry.yearOfManufacture;
    p.operatingPrinciple = entry.operatingPrinciple;
    p.measurementRange = entry.measurementRange;
    p.sensitivityAccuracy = entry.sensitivityAccuracy;
    p.attachmentMethod = entry.attachmentMethod;
    p.materials = entry.materials;
    p.dimensions = entry.dimensions;
    p.conditionState = entry.conditionState;
    p.accessories = entry.accessories;
    p.hasCalibrationCert = entry.hasCalibrationCert;
    p.provenance = entry.provenance;
    p.notes = entry.notes;
    p.photoPath = entry.photoPath;
    p.tags = List<String>.from(entry.tags);
    p.dateAdded = entry.dateAdded;

    imgProv.resultImage = entry.photoPath;

    notifyListeners();
  }
}

final projectProvider = ChangeNotifierProvider<ProjectNotifier>(
  (ref) => ProjectNotifier(),
);

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rebar_bender_cabinet/enum/my_enums.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Input Provider — manages form state for add/edit screen
// ─────────────────────────────────────────────────────────────────────────────

class InputNotifier extends ChangeNotifier {
  // Core identification
  String catalogueIdentifier = '';
  String toolName = '';

  // Classification
  ToolType toolType = ToolType.manualBender;
  OperationMethod operationMethod = OperationMethod.handOperated;
  ConditionState conditionState = ConditionState.good;

  // Provenance
  String manufacturer = '';
  String countryOfOrigin = '';
  String eraOfProduction = '';
  String modelNumber = '';
  String serialNumber = '';

  // Technical specs
  String rebarSizeCapacity = '';
  String bendAngleRange = '';
  String material = '';
  String weight = '';

  // Collector notes
  String provenance = '';
  String notes = '';
  String tags = '';

  // ── Validation ────────────────────────────────────────────────────────────
  bool get isBasicInfoValid => toolName.trim().isNotEmpty && catalogueIdentifier.trim().isNotEmpty;

  // ── Setters ──────────────────────────────────────────────────────────────

  void setCatalogueIdentifier(String v) {
    catalogueIdentifier = v;
    notifyListeners();
  }

  void setToolName(String v) {
    toolName = v;
    notifyListeners();
  }

  void setToolType(ToolType v) {
    toolType = v;
    notifyListeners();
  }

  void setOperationMethod(OperationMethod v) {
    operationMethod = v;
    notifyListeners();
  }

  void setConditionState(ConditionState v) {
    conditionState = v;
    notifyListeners();
  }

  void setManufacturer(String v) {
    manufacturer = v;
    notifyListeners();
  }

  void setCountryOfOrigin(String v) {
    countryOfOrigin = v;
    notifyListeners();
  }

  void setEraOfProduction(String v) {
    eraOfProduction = v;
    notifyListeners();
  }

  void setModelNumber(String v) {
    modelNumber = v;
    notifyListeners();
  }

  void setSerialNumber(String v) {
    serialNumber = v;
    notifyListeners();
  }

  void setRebarSizeCapacity(String v) {
    rebarSizeCapacity = v;
    notifyListeners();
  }

  void setBendAngleRange(String v) {
    bendAngleRange = v;
    notifyListeners();
  }

  void setMaterial(String v) {
    material = v;
    notifyListeners();
  }

  void setWeight(String v) {
    weight = v;
    notifyListeners();
  }

  void setProvenance(String v) {
    provenance = v;
    notifyListeners();
  }

  void setNotes(String v) {
    notes = v;
    notifyListeners();
  }

  void setTags(String v) {
    tags = v;
    notifyListeners();
  }

  // ── Public notify ─────────────────────────────────────────────────────────

  // Called externally (e.g. by project_provider) to trigger UI rebuild.
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  void notifyAll() => notifyListeners();

  // ── Clear / Reset ─────────────────────────────────────────────────────────

  void clearAll() {
    catalogueIdentifier = '';
    toolName = '';
    toolType = ToolType.manualBender;
    operationMethod = OperationMethod.handOperated;
    conditionState = ConditionState.good;
    manufacturer = '';
    countryOfOrigin = '';
    eraOfProduction = '';
    modelNumber = '';
    serialNumber = '';
    rebarSizeCapacity = '';
    bendAngleRange = '';
    material = '';
    weight = '';
    provenance = '';
    notes = '';
    tags = '';
    notifyListeners();
  }
}

final inputProvider = ChangeNotifierProvider<InputNotifier>((ref) {
  return InputNotifier();
});

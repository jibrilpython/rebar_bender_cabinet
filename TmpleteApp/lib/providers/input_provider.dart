import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:strain_guage_box/enum/my_enums.dart';

class InputNotifier extends ChangeNotifier {
  String _testIdentifier = '';
  String _instrumentName = '';
  InstrumentType _instrumentType = InstrumentType.mechanicalTensometer;
  String _manufacturer = '';
  String _model = '';
  String _countryOfManufacture = '';
  int _yearOfManufacture = 1950;
  OperatingPrinciple _operatingPrinciple = OperatingPrinciple.mechanical;
  String _measurementRange = '';
  String _sensitivityAccuracy = '';
  String _attachmentMethod = '';
  String _materials = '';
  String _dimensions = '';
  ConditionState _conditionState = ConditionState.unknown;
  String _accessories = '';
  bool _hasCalibrationCert = false;
  String _provenance = '';
  String _notes = '';
  String _photoPath = '';
  List<String> _tags = [];
  DateTime _dateAdded = DateTime.now();

  // Getters
  String get testIdentifier => _testIdentifier;
  String get instrumentName => _instrumentName;
  InstrumentType get instrumentType => _instrumentType;
  String get manufacturer => _manufacturer;
  String get model => _model;
  String get countryOfManufacture => _countryOfManufacture;
  int get yearOfManufacture => _yearOfManufacture;
  OperatingPrinciple get operatingPrinciple => _operatingPrinciple;
  String get measurementRange => _measurementRange;
  String get sensitivityAccuracy => _sensitivityAccuracy;
  String get attachmentMethod => _attachmentMethod;
  String get materials => _materials;
  String get dimensions => _dimensions;
  ConditionState get conditionState => _conditionState;
  String get accessories => _accessories;
  bool get hasCalibrationCert => _hasCalibrationCert;
  String get provenance => _provenance;
  String get notes => _notes;
  String get photoPath => _photoPath;
  List<String> get tags => _tags;
  DateTime get dateAdded => _dateAdded;

  // Setters
  set testIdentifier(String v) { _testIdentifier = v; notifyListeners(); }
  set instrumentName(String v) { _instrumentName = v; notifyListeners(); }
  set instrumentType(InstrumentType v) { _instrumentType = v; notifyListeners(); }
  set manufacturer(String v) { _manufacturer = v; notifyListeners(); }
  set model(String v) { _model = v; notifyListeners(); }
  set countryOfManufacture(String v) { _countryOfManufacture = v; notifyListeners(); }
  set yearOfManufacture(int v) { _yearOfManufacture = v; notifyListeners(); }
  set operatingPrinciple(OperatingPrinciple v) { _operatingPrinciple = v; notifyListeners(); }
  set measurementRange(String v) { _measurementRange = v; notifyListeners(); }
  set sensitivityAccuracy(String v) { _sensitivityAccuracy = v; notifyListeners(); }
  set attachmentMethod(String v) { _attachmentMethod = v; notifyListeners(); }
  set materials(String v) { _materials = v; notifyListeners(); }
  set dimensions(String v) { _dimensions = v; notifyListeners(); }
  set conditionState(ConditionState v) { _conditionState = v; notifyListeners(); }
  set accessories(String v) { _accessories = v; notifyListeners(); }
  set hasCalibrationCert(bool v) { _hasCalibrationCert = v; notifyListeners(); }
  set provenance(String v) { _provenance = v; notifyListeners(); }
  set notes(String v) { _notes = v; notifyListeners(); }
  set photoPath(String v) { _photoPath = v; notifyListeners(); }
  set tags(List<String> v) { _tags = v; notifyListeners(); }
  set dateAdded(DateTime v) { _dateAdded = v; notifyListeners(); }

  void clearAll() {
    _testIdentifier = '';
    _instrumentName = '';
    _instrumentType = InstrumentType.mechanicalTensometer;
    _manufacturer = '';
    _model = '';
    _countryOfManufacture = '';
    _yearOfManufacture = 1950;
    _operatingPrinciple = OperatingPrinciple.mechanical;
    _measurementRange = '';
    _sensitivityAccuracy = '';
    _attachmentMethod = '';
    _materials = '';
    _dimensions = '';
    _conditionState = ConditionState.unknown;
    _accessories = '';
    _hasCalibrationCert = false;
    _provenance = '';
    _notes = '';
    _photoPath = '';
    _tags = [];
    _dateAdded = DateTime.now();
    notifyListeners();
  }
}

final inputProvider = ChangeNotifierProvider<InputNotifier>(
  (ref) => InputNotifier(),
);

import 'package:strain_guage_box/enum/my_enums.dart';

class StrainGaugeModel {
  String id;
  String testIdentifier;
  String instrumentName;
  InstrumentType instrumentType;
  String manufacturer;
  String model;
  String countryOfManufacture;
  int yearOfManufacture;
  OperatingPrinciple operatingPrinciple;
  String measurementRange;
  String sensitivityAccuracy;
  String attachmentMethod;
  String materials;
  String dimensions;
  ConditionState conditionState;
  String accessories;
  bool hasCalibrationCert;
  String provenance;
  String notes;
  String photoPath;
  List<String> tags;
  DateTime dateAdded;

  StrainGaugeModel({
    required this.id,
    required this.testIdentifier,
    required this.instrumentName,
    required this.instrumentType,
    required this.manufacturer,
    required this.model,
    required this.countryOfManufacture,
    required this.yearOfManufacture,
    required this.operatingPrinciple,
    required this.measurementRange,
    required this.sensitivityAccuracy,
    required this.attachmentMethod,
    required this.materials,
    required this.dimensions,
    required this.conditionState,
    required this.accessories,
    required this.hasCalibrationCert,
    required this.provenance,
    required this.notes,
    required this.photoPath,
    required this.tags,
    required this.dateAdded,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'testIdentifier': testIdentifier,
        'instrumentName': instrumentName,
        'instrumentType': instrumentType.name,
        'manufacturer': manufacturer,
        'model': model,
        'countryOfManufacture': countryOfManufacture,
        'yearOfManufacture': yearOfManufacture,
        'operatingPrinciple': operatingPrinciple.name,
        'measurementRange': measurementRange,
        'sensitivityAccuracy': sensitivityAccuracy,
        'attachmentMethod': attachmentMethod,
        'materials': materials,
        'dimensions': dimensions,
        'conditionState': conditionState.name,
        'accessories': accessories,
        'hasCalibrationCert': hasCalibrationCert,
        'provenance': provenance,
        'notes': notes,
        'photoPath': photoPath,
        'tags': tags,
        'dateAdded': dateAdded.toIso8601String(),
      };

  factory StrainGaugeModel.fromJson(Map<String, dynamic> json) =>
      StrainGaugeModel(
        id: json['id'] ?? '',
        testIdentifier: json['testIdentifier'] ?? '',
        instrumentName: json['instrumentName'] ?? '',
        instrumentType:
            InstrumentType.values.asNameMap()[json['instrumentType']] ??
                InstrumentType.other,
        manufacturer: json['manufacturer'] ?? '',
        model: json['model'] ?? '',
        countryOfManufacture: json['countryOfManufacture'] ?? '',
        yearOfManufacture: json['yearOfManufacture'] ?? 1950,
        operatingPrinciple:
            OperatingPrinciple.values.asNameMap()[json['operatingPrinciple']] ??
                OperatingPrinciple.mechanical,
        measurementRange: json['measurementRange'] ?? '',
        sensitivityAccuracy: json['sensitivityAccuracy'] ?? '',
        attachmentMethod: json['attachmentMethod'] ?? '',
        materials: json['materials'] ?? '',
        dimensions: json['dimensions'] ?? '',
        conditionState:
            ConditionState.values.asNameMap()[json['conditionState']] ??
                ConditionState.unknown,
        accessories: json['accessories'] ?? '',
        hasCalibrationCert: json['hasCalibrationCert'] ?? false,
        provenance: json['provenance'] ?? '',
        notes: json['notes'] ?? '',
        photoPath: json['photoPath'] ?? '',
        tags: List<String>.from(json['tags'] ?? []),
        dateAdded:
            DateTime.tryParse(json['dateAdded'] ?? '') ?? DateTime.now(),
      );
}

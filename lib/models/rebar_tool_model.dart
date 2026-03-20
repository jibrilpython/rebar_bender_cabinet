import 'package:rebar_bender_cabinet/enum/my_enums.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Data Model for The Rebar Bender Archive
// ─────────────────────────────────────────────────────────────────────────────

class RebarToolModel {
  // Core identification
  final String? id;
  final String? catalogueIdentifier;
  final String? toolName;

  // Classification
  final ToolType? toolType;
  final OperationMethod? operationMethod;
  final ConditionState? conditionState;

  // Provenance & history
  final String? manufacturer;
  final String? countryOfOrigin;
  final String? eraOfProduction; // e.g. "1970s", "Early 1900s"
  final String? modelNumber;
  final String? serialNumber;

  // Technical specifications
  final String? rebarSizeCapacity; // e.g. "#3 - #8"
  final String? bendAngleRange; // e.g. "0° – 180°"
  final String? material; // e.g. "Cast Iron", "Steel"
  final String? weight; // e.g. "45 kg"

  // Collector notes
  final String? provenance; // Where/how it was acquired
  final String? notes;
  final String? tags;

  // Media
  final String? imagePath;

  const RebarToolModel({
    this.id,
    this.catalogueIdentifier,
    this.toolName,
    this.toolType,
    this.operationMethod,
    this.conditionState,
    this.manufacturer,
    this.countryOfOrigin,
    this.eraOfProduction,
    this.modelNumber,
    this.serialNumber,
    this.rebarSizeCapacity,
    this.bendAngleRange,
    this.material,
    this.weight,
    this.provenance,
    this.notes,
    this.tags,
    this.imagePath,
  });

  // ── JSON serialization ────────────────────────────────────────────────────

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'catalogueIdentifier': catalogueIdentifier,
      'toolName': toolName,
      'toolType': toolType?.name,
      'operationMethod': operationMethod?.name,
      'conditionState': conditionState?.name,
      'manufacturer': manufacturer,
      'countryOfOrigin': countryOfOrigin,
      'eraOfProduction': eraOfProduction,
      'modelNumber': modelNumber,
      'serialNumber': serialNumber,
      'rebarSizeCapacity': rebarSizeCapacity,
      'bendAngleRange': bendAngleRange,
      'material': material,
      'weight': weight,
      'provenance': provenance,
      'notes': notes,
      'tags': tags,
      'imagePath': imagePath,
    };
  }

  factory RebarToolModel.fromJson(Map<String, dynamic> json) {
    return RebarToolModel(
      id: json['id'] as String?,
      catalogueIdentifier: json['catalogueIdentifier'] as String?,
      toolName: json['toolName'] as String?,
      toolType: json['toolType'] != null
          ? ToolType.values.firstWhere(
              (e) => e.name == json['toolType'],
              orElse: () => ToolType.other,
            )
          : null,
      operationMethod: json['operationMethod'] != null
          ? OperationMethod.values.firstWhere(
              (e) => e.name == json['operationMethod'],
              orElse: () => OperationMethod.unknown,
            )
          : null,
      conditionState: json['conditionState'] != null
          ? ConditionState.values.firstWhere(
              (e) => e.name == json['conditionState'],
              orElse: () => ConditionState.fair,
            )
          : null,
      manufacturer: json['manufacturer'] as String?,
      countryOfOrigin: json['countryOfOrigin'] as String?,
      eraOfProduction: json['eraOfProduction'] as String?,
      modelNumber: json['modelNumber'] as String?,
      serialNumber: json['serialNumber'] as String?,
      rebarSizeCapacity: json['rebarSizeCapacity'] as String?,
      bendAngleRange: json['bendAngleRange'] as String?,
      material: json['material'] as String?,
      weight: json['weight'] as String?,
      provenance: json['provenance'] as String?,
      notes: json['notes'] as String?,
      tags: json['tags'] as String?,
      imagePath: json['imagePath'] as String?,
    );
  }

  // ── CopyWith ──────────────────────────────────────────────────────────────

  RebarToolModel copyWith({
    String? id,
    String? catalogueIdentifier,
    String? toolName,
    ToolType? toolType,
    OperationMethod? operationMethod,
    ConditionState? conditionState,
    String? manufacturer,
    String? countryOfOrigin,
    String? eraOfProduction,
    String? modelNumber,
    String? serialNumber,
    String? rebarSizeCapacity,
    String? bendAngleRange,
    String? material,
    String? weight,
    String? provenance,
    String? notes,
    String? tags,
    String? imagePath,
  }) {
    return RebarToolModel(
      id: id ?? this.id,
      catalogueIdentifier: catalogueIdentifier ?? this.catalogueIdentifier,
      toolName: toolName ?? this.toolName,
      toolType: toolType ?? this.toolType,
      operationMethod: operationMethod ?? this.operationMethod,
      conditionState: conditionState ?? this.conditionState,
      manufacturer: manufacturer ?? this.manufacturer,
      countryOfOrigin: countryOfOrigin ?? this.countryOfOrigin,
      eraOfProduction: eraOfProduction ?? this.eraOfProduction,
      modelNumber: modelNumber ?? this.modelNumber,
      serialNumber: serialNumber ?? this.serialNumber,
      rebarSizeCapacity: rebarSizeCapacity ?? this.rebarSizeCapacity,
      bendAngleRange: bendAngleRange ?? this.bendAngleRange,
      material: material ?? this.material,
      weight: weight ?? this.weight,
      provenance: provenance ?? this.provenance,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

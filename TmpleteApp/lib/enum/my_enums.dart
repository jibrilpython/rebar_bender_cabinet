enum InstrumentType {
  mechanicalTensometer('Mechanical Tensometer'),
  opticalTensometer('Optical Tensometer'),
  pneumaticExtensometer('Pneumatic Extensometer'),
  deflectometer('Deflectometer'),
  vibrograph('Vibrograph'),
  vibratingWire('Vibrating Wire'),
  wireFoilGauge('Wire / Foil Gauge'),
  other('Other');

  const InstrumentType(this.label);
  final String label;
}

enum OperatingPrinciple {
  mechanical('Mechanical (Lever/Gear)'),
  optical('Optical (Mirror)'),
  electricalWire('Electrical (Wire)'),
  electricalFoil('Electrical (Foil)'),
  vibratingWire('Vibrating Wire'),
  pneumatic('Pneumatic');

  const OperatingPrinciple(this.label);
  final String label;
}

enum ConditionState {
  operational('Operational'),
  requiresCalibration('Requires Calibration'),
  museumQuality('Museum Quality'),
  forParts('For Parts'),
  unknown('Unknown');

  const ConditionState(this.label);
  final String label;
}

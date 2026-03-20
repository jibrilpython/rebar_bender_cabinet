// ─────────────────────────────────────────────────────────────────────────────
//  Enums for The Rebar Bender Archive
// ─────────────────────────────────────────────────────────────────────────────

enum ToolType {
  manualBender,
  electromechanicalBender,
  hydraulicBender,
  pneumaticBender,
  portableBender,
  benchMountedBender,
  cnCBender,
  other;

  String get displayName {
    switch (this) {
      case ToolType.manualBender:
        return 'Manual Bender';
      case ToolType.electromechanicalBender:
        return 'Electromechanical';
      case ToolType.hydraulicBender:
        return 'Hydraulic Bender';
      case ToolType.pneumaticBender:
        return 'Pneumatic Bender';
      case ToolType.portableBender:
        return 'Portable Bender';
      case ToolType.benchMountedBender:
        return 'Bench-Mounted';
      case ToolType.cnCBender:
        return 'CNC Bender';
      case ToolType.other:
        return 'Other';
    }
  }
}

enum OperationMethod {
  handOperated,
  footPedal,
  electricMotor,
  hydraulicActuator,
  pneumaticActuator,
  cnCControlled,
  unknown;

  String get displayName {
    switch (this) {
      case OperationMethod.handOperated:
        return 'Hand Operated';
      case OperationMethod.footPedal:
        return 'Foot Pedal';
      case OperationMethod.electricMotor:
        return 'Electric Motor';
      case OperationMethod.hydraulicActuator:
        return 'Hydraulic Actuator';
      case OperationMethod.pneumaticActuator:
        return 'Pneumatic Actuator';
      case OperationMethod.cnCControlled:
        return 'CNC Controlled';
      case OperationMethod.unknown:
        return 'Unknown';
    }
  }
}

enum ConditionState {
  mint,
  excellent,
  good,
  fair,
  poor,
  restoration;

  String get displayName {
    switch (this) {
      case ConditionState.mint:
        return 'Mint';
      case ConditionState.excellent:
        return 'Excellent';
      case ConditionState.good:
        return 'Good';
      case ConditionState.fair:
        return 'Fair';
      case ConditionState.poor:
        return 'Poor';
      case ConditionState.restoration:
        return 'For Restoration';
    }
  }
}

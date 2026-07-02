import 'package:flutter/services.dart';

import '../models/call_types.dart';

class CallDecision {
  const CallDecision({
    required this.type,
    required this.action,
    required this.explanation,
    this.canAnswerAutomatically = false,
    this.canHangUp = false,
  });

  final CallType type;
  final CallAction action;
  final String explanation;
  final bool canAnswerAutomatically;
  final bool canHangUp;
}

class CallService {
  static const _channel = MethodChannel('sam_raccroche_ia/calls');

  Future<bool> isDefaultDialer() async {
    try {
      return await _channel.invokeMethod<bool>('isDefaultDialer') ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<void> requestDefaultDialerRole() async {
    try {
      await _channel.invokeMethod<void>('requestDefaultDialerRole');
    } on PlatformException {
      // Android moderne limite ces actions. L UI affiche une alternative manuelle.
    }
  }

  Future<bool> hangUpIfAllowed() async {
    try {
      return await _channel.invokeMethod<bool>('hangUp') ?? false;
    } on PlatformException {
      return false;
    }
  }

  CallDecision evaluate({
    required String number,
    required bool protectionEnabled,
    required List<String> blacklist,
    required List<String> whitelist,
    required List<String> blockedPrefixes,
    required bool insideAllowedHours,
  }) {
    if (!protectionEnabled) {
      return const CallDecision(
        type: CallType.unknown,
        action: CallAction.allowed,
        explanation: 'Protection desactivee.',
      );
    }
    if (number.trim().isEmpty || number == 'Masque') {
      return const CallDecision(
        type: CallType.hidden,
        action: CallAction.notified,
        explanation: 'Numero masque ou indisponible.',
      );
    }
    if (whitelist.contains(number)) {
      return const CallDecision(
        type: CallType.whitelisted,
        action: CallAction.allowed,
        explanation: 'Numero autorise.',
      );
    }
    if (blacklist.contains(number)) {
      return const CallDecision(
        type: CallType.blacklisted,
        action: CallAction.blocked,
        explanation: 'Numero en liste noire.',
      );
    }
    if (blockedPrefixes.any(number.startsWith)) {
      return const CallDecision(
        type: CallType.prefixBlocked,
        action: CallAction.blocked,
        explanation: 'Prefixe bloque.',
      );
    }
    if (!insideAllowedHours) {
      return const CallDecision(
        type: CallType.outsideHours,
        action: CallAction.notified,
        explanation: 'Appel hors horaires de protection.',
      );
    }
    return const CallDecision(
      type: CallType.suspicious,
      action: CallAction.scriptShown,
      explanation: 'Numero inconnu : scenario IA conseille.',
    );
  }
}

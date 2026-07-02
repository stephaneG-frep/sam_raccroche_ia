enum CallType {
  unknown('Inconnu'),
  hidden('Masque'),
  suspicious('Suspect'),
  blacklisted('Liste noire'),
  whitelisted('Liste blanche'),
  prefixBlocked('Prefixe bloque'),
  outsideHours('Hors horaires');

  const CallType(this.label);
  final String label;

  static CallType fromName(String? name) {
    return CallType.values.firstWhere(
      (value) => value.name == name,
      orElse: () => CallType.unknown,
    );
  }
}

enum CallAction {
  notified('Notification'),
  blocked('Bloque'),
  scriptShown('Script affiche'),
  messagePlayed('Message lu'),
  hangupRequested('Raccrochage demande'),
  allowed('Autorise');

  const CallAction(this.label);
  final String label;

  static CallAction fromName(String? name) {
    return CallAction.values.firstWhere(
      (value) => value.name == name,
      orElse: () => CallAction.notified,
    );
  }
}

enum AiTone {
  funny('Drole'),
  polite('Poli'),
  dry('Tres sec'),
  absurd('Absurde');

  const AiTone(this.label);
  final String label;

  static AiTone fromName(String? name) {
    return AiTone.values.firstWhere(
      (value) => value.name == name,
      orElse: () => AiTone.funny,
    );
  }
}

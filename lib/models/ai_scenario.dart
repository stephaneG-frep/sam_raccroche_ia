import 'call_types.dart';

class AiScenario {
  const AiScenario({
    required this.id,
    required this.name,
    required this.tone,
    required this.lines,
    this.enabled = true,
  });

  final String id;
  final String name;
  final AiTone tone;
  final List<String> lines;
  final bool enabled;

  String get firstLine => lines.isEmpty ? '' : lines.first;

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'tone': tone.name,
    'lines': lines,
    'enabled': enabled,
  };

  factory AiScenario.fromMap(Map<dynamic, dynamic> map) => AiScenario(
    id: map['id'] as String,
    name: map['name'] as String? ?? '',
    tone: AiTone.fromName(map['tone'] as String?),
    lines: List<String>.from(map['lines'] as List? ?? const []),
    enabled: map['enabled'] as bool? ?? true,
  );
}

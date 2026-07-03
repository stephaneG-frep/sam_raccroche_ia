import 'call_types.dart';

class AiScenario {
  const AiScenario({
    required this.id,
    required this.name,
    required this.tone,
    required this.lines,
    this.selectedLineIndex = 0,
    this.enabled = true,
  });

  final String id;
  final String name;
  final AiTone tone;
  final List<String> lines;
  final int selectedLineIndex;
  final bool enabled;

  String get firstLine => lines.isEmpty ? '' : lines.first;

  String get selectedLine {
    if (lines.isEmpty) return '';
    final index = selectedLineIndex.clamp(0, lines.length - 1).toInt();
    return lines[index];
  }

  AiScenario copyWith({int? selectedLineIndex}) => AiScenario(
    id: id,
    name: name,
    tone: tone,
    lines: lines,
    selectedLineIndex: selectedLineIndex ?? this.selectedLineIndex,
    enabled: enabled,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'tone': tone.name,
    'lines': lines,
    'selectedLineIndex': selectedLineIndex,
    'enabled': enabled,
  };

  factory AiScenario.fromMap(Map<dynamic, dynamic> map) => AiScenario(
    id: map['id'] as String,
    name: map['name'] as String? ?? '',
    tone: AiTone.fromName(map['tone'] as String?),
    lines: List<String>.from(map['lines'] as List? ?? const []),
    selectedLineIndex: map['selectedLineIndex'] as int? ?? 0,
    enabled: map['enabled'] as bool? ?? true,
  );
}

import 'call_types.dart';

class CallLogEntry {
  const CallLogEntry({
    required this.id,
    required this.date,
    required this.number,
    required this.type,
    required this.action,
    required this.messageUsed,
    required this.scenarioUsed,
    required this.estimatedDurationSeconds,
    this.note = '',
  });

  final String id;
  final DateTime date;
  final String number;
  final CallType type;
  final CallAction action;
  final String messageUsed;
  final String scenarioUsed;
  final int estimatedDurationSeconds;
  final String note;

  CallLogEntry copyWith({String? note}) => CallLogEntry(
    id: id,
    date: date,
    number: number,
    type: type,
    action: action,
    messageUsed: messageUsed,
    scenarioUsed: scenarioUsed,
    estimatedDurationSeconds: estimatedDurationSeconds,
    note: note ?? this.note,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'number': number,
    'type': type.name,
    'action': action.name,
    'messageUsed': messageUsed,
    'scenarioUsed': scenarioUsed,
    'estimatedDurationSeconds': estimatedDurationSeconds,
    'note': note,
  };

  factory CallLogEntry.fromMap(Map<dynamic, dynamic> map) => CallLogEntry(
    id: map['id'] as String,
    date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
    number: map['number'] as String? ?? '',
    type: CallType.fromName(map['type'] as String?),
    action: CallAction.fromName(map['action'] as String?),
    messageUsed: map['messageUsed'] as String? ?? '',
    scenarioUsed: map['scenarioUsed'] as String? ?? '',
    estimatedDurationSeconds: map['estimatedDurationSeconds'] as int? ?? 0,
    note: map['note'] as String? ?? '',
  );
}

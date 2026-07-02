class BlockedNumber {
  const BlockedNumber({
    required this.id,
    required this.number,
    required this.label,
    required this.createdAt,
    this.reason = '',
  });

  final String id;
  final String number;
  final String label;
  final String reason;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
    'id': id,
    'number': number,
    'label': label,
    'reason': reason,
    'createdAt': createdAt.toIso8601String(),
  };

  factory BlockedNumber.fromMap(Map<dynamic, dynamic> map) => BlockedNumber(
    id: map['id'] as String,
    number: map['number'] as String? ?? '',
    label: map['label'] as String? ?? '',
    reason: map['reason'] as String? ?? '',
    createdAt:
        DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
  );
}

class AllowedNumber {
  const AllowedNumber({
    required this.id,
    required this.number,
    required this.label,
    required this.createdAt,
  });

  final String id;
  final String number;
  final String label;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
    'id': id,
    'number': number,
    'label': label,
    'createdAt': createdAt.toIso8601String(),
  };

  factory AllowedNumber.fromMap(Map<dynamic, dynamic> map) => AllowedNumber(
    id: map['id'] as String,
    number: map['number'] as String? ?? '',
    label: map['label'] as String? ?? '',
    createdAt:
        DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
  );
}

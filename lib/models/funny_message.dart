class FunnyMessage {
  const FunnyMessage({
    required this.id,
    required this.title,
    required this.text,
    this.isDefault = false,
    this.audioPath,
  });

  final String id;
  final String title;
  final String text;
  final bool isDefault;
  final String? audioPath;

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'text': text,
    'isDefault': isDefault,
    'audioPath': audioPath,
  };

  factory FunnyMessage.fromMap(Map<dynamic, dynamic> map) => FunnyMessage(
    id: map['id'] as String,
    title: map['title'] as String? ?? '',
    text: map['text'] as String? ?? '',
    isDefault: map['isDefault'] as bool? ?? false,
    audioPath: map['audioPath'] as String?,
  );
}

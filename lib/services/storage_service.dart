import 'package:hive_flutter/hive_flutter.dart';

import '../models/ai_scenario.dart';
import '../models/allowed_number.dart';
import '../models/blocked_number.dart';
import '../models/call_log_entry.dart';
import '../models/call_types.dart';
import '../models/funny_message.dart';

class StorageService {
  static const _blockedBox = 'blocked_numbers';
  static const _allowedBox = 'allowed_numbers';
  static const _logsBox = 'call_logs';
  static const _messagesBox = 'funny_messages';
  static const _scenariosBox = 'ai_scenarios';
  static const _settingsBox = 'settings';

  late Box blocked;
  late Box allowed;
  late Box logs;
  late Box messages;
  late Box scenarios;
  late Box settings;

  Future<void> init() async {
    await Hive.initFlutter();
    blocked = await Hive.openBox(_blockedBox);
    allowed = await Hive.openBox(_allowedBox);
    logs = await Hive.openBox(_logsBox);
    messages = await Hive.openBox(_messagesBox);
    scenarios = await Hive.openBox(_scenariosBox);
    settings = await Hive.openBox(_settingsBox);
    await _seedDefaults();
  }

  Future<void> _seedDefaults() async {
    if (messages.isEmpty) {
      for (final message in defaultMessages) {
        await messages.put(message.id, message.toMap());
      }
    }
    if (scenarios.isEmpty) {
      for (final scenario in defaultScenarios) {
        await scenarios.put(scenario.id, scenario.toMap());
      }
    }
  }

  List<BlockedNumber> blockedNumbers() => blocked.values
      .map(
        (value) =>
            BlockedNumber.fromMap(Map<dynamic, dynamic>.from(value as Map)),
      )
      .toList();

  List<AllowedNumber> allowedNumbers() => allowed.values
      .map(
        (value) =>
            AllowedNumber.fromMap(Map<dynamic, dynamic>.from(value as Map)),
      )
      .toList();

  List<CallLogEntry> callLogs() =>
      logs.values
          .map(
            (value) =>
                CallLogEntry.fromMap(Map<dynamic, dynamic>.from(value as Map)),
          )
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  List<FunnyMessage> funnyMessages() => messages.values
      .map(
        (value) =>
            FunnyMessage.fromMap(Map<dynamic, dynamic>.from(value as Map)),
      )
      .toList();

  List<AiScenario> aiScenarios() => scenarios.values
      .map(
        (value) => AiScenario.fromMap(Map<dynamic, dynamic>.from(value as Map)),
      )
      .toList();

  Future<void> saveBlocked(BlockedNumber number) =>
      blocked.put(number.id, number.toMap());
  Future<void> deleteBlocked(String id) => blocked.delete(id);
  Future<void> saveAllowed(AllowedNumber number) =>
      allowed.put(number.id, number.toMap());
  Future<void> deleteAllowed(String id) => allowed.delete(id);
  Future<void> saveLog(CallLogEntry entry) => logs.put(entry.id, entry.toMap());
  Future<void> clearLogs() => logs.clear();
  Future<void> saveMessage(FunnyMessage message) =>
      messages.put(message.id, message.toMap());
  Future<void> saveScenario(AiScenario scenario) =>
      scenarios.put(scenario.id, scenario.toMap());
  Future<void> clearAll() async {
    await blocked.clear();
    await allowed.clear();
    await logs.clear();
    await messages.clear();
    await scenarios.clear();
    await settings.clear();
    await _seedDefaults();
  }

  T setting<T>(String key, T fallback) =>
      settings.get(key, defaultValue: fallback) as T;
  Future<void> setSetting(String key, Object? value) =>
      settings.put(key, value);
}

const defaultFunnyText = '''
Bonjour, votre appel est important pour nous.
Enfin... pas trop.
Veuillez patienter pendant que notre intelligence artificielle decide si vous meritez un humain.
Temps d'attente estime : 47 ans.
''';

final defaultMessages = [
  const FunnyMessage(
    id: 'default_wait',
    title: 'Attente 47 ans',
    text: defaultFunnyText,
    isDefault: true,
  ),
  const FunnyMessage(
    id: 'robot_filter',
    title: 'Filtre robot',
    text:
        'Bonjour. Pour parler a Stephane, prouvez que vous n etes pas un robot motive par les commissions.',
  ),
  const FunnyMessage(
    id: 'committee',
    title: 'Comite imaginaire',
    text:
        'Veuillez patienter pendant que je consulte le comite imaginaire de validation des appels.',
  ),
];

final defaultScenarios = [
  const AiScenario(
    id: 'funny',
    name: 'Mode drole',
    tone: AiTone.funny,
    lines: [
      'Bonjour, je suis l assistant virtuel de Stephane. Etes-vous un humain ou un robot motive par les commissions ?',
      'Votre appel est numero 784 dans la file d attente. Temps estime : apres la retraite des grille-pains.',
      'Si vous appelez pour une offre exceptionnelle, sachez que nous avons deja une collection complete.',
    ],
  ),
  const AiScenario(
    id: 'polite',
    name: 'Mode poli',
    tone: AiTone.polite,
    lines: [
      'Bonjour. Merci d expliquer en une phrase l objet exact de votre appel.',
      'Si votre demande est commerciale, merci de l envoyer par ecrit.',
    ],
  ),
  const AiScenario(
    id: 'dry',
    name: 'Mode tres sec',
    tone: AiTone.dry,
    lines: [
      'Bonjour. Appel non sollicite detecte. Merci de raccrocher.',
      'Sans motif clair et utile, l appel sera ignore.',
    ],
  ),
  const AiScenario(
    id: 'absurd',
    name: 'Mode absurde',
    tone: AiTone.absurd,
    lines: [
      'Veuillez patienter pendant que je demande l avis du grille-pain juridique.',
      'Le service humain est actuellement parti verifier si les promotions ont une ame.',
    ],
  ),
];

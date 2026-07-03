import 'package:flutter/foundation.dart';

import '../models/ai_scenario.dart';
import '../models/call_types.dart';
import '../models/funny_message.dart';
import '../services/storage_service.dart';
import '../services/tts_service.dart';

class ResponderProvider extends ChangeNotifier {
  ResponderProvider(this.storage, this.tts);

  final StorageService storage;
  final TtsService tts;
  final List<FunnyMessage> messages = [];
  final List<AiScenario> scenarios = [];
  String selectedMessageId = 'default_wait';
  String selectedScenarioId = 'funny';
  String detectedResponse = '';

  FunnyMessage get selectedMessage => messages.firstWhere(
    (message) => message.id == selectedMessageId,
    orElse: () => messages.first,
  );

  AiScenario get selectedScenario => scenarios.firstWhere(
    (scenario) => scenario.id == selectedScenarioId,
    orElse: () => scenarios.first,
  );

  String get selectedScenarioLine => selectedScenario.selectedLine;

  void load() {
    messages
      ..clear()
      ..addAll(storage.funnyMessages());
    scenarios
      ..clear()
      ..addAll(storage.aiScenarios());
    selectedMessageId = storage.setting('selectedMessageId', 'default_wait');
    final defaultTone = AiTone.fromName(
      storage.setting('defaultTone', AiTone.funny.name),
    );
    selectedScenarioId = storage.setting(
      'selectedScenarioId',
      scenarios
          .firstWhere(
            (scenario) => scenario.tone == defaultTone,
            orElse: () => scenarios.first,
          )
          .id,
    );
    notifyListeners();
  }

  Future<void> selectMessage(String id) async {
    selectedMessageId = id;
    await storage.setSetting('selectedMessageId', id);
    notifyListeners();
  }

  Future<void> selectScenario(String id) async {
    selectedScenarioId = id;
    await storage.setSetting('selectedScenarioId', id);
    notifyListeners();
  }

  Future<void> selectScenarioLine(int index) async {
    final scenario = selectedScenario.copyWith(selectedLineIndex: index);
    final scenarioIndex = scenarios.indexWhere(
      (item) => item.id == scenario.id,
    );
    if (scenarioIndex < 0) return;
    scenarios[scenarioIndex] = scenario;
    await storage.saveScenario(scenario);
    notifyListeners();
  }

  Future<void> selectTone(AiTone tone) async {
    final scenario = scenarios.firstWhere(
      (item) => item.tone == tone,
      orElse: () => scenarios.first,
    );
    await selectScenario(scenario.id);
    await storage.setSetting('defaultTone', tone.name);
  }

  Future<void> saveCustomMessage(String title, String text) async {
    final message = FunnyMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      text: text,
    );
    await storage.saveMessage(message);
    load();
  }

  Future<void> previewSelectedMessage() => tts.speak(selectedMessage.text);
  Future<void> speakLine(String text) => tts.speak(text);

  List<String> linesForTone(AiTone tone) {
    return scenarios
        .where((scenario) => scenario.tone == tone)
        .expand((scenario) => scenario.lines)
        .toList();
  }

  void setDetectedResponse(String value) {
    detectedResponse = value;
    notifyListeners();
  }
}

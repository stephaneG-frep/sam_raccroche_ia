import 'package:flutter/foundation.dart';

import '../models/call_log_entry.dart';
import '../models/call_types.dart';
import '../services/call_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import 'numbers_provider.dart';
import 'responder_provider.dart';
import 'settings_provider.dart';

class ProtectionProvider extends ChangeNotifier {
  ProtectionProvider(this.storage, this.callService, this.notifications);

  final StorageService storage;
  final CallService callService;
  final NotificationService notifications;

  bool enabled = true;
  bool defaultDialer = false;
  final List<CallLogEntry> logs = [];
  String query = '';
  CallType? filter;

  List<CallLogEntry> get filteredLogs {
    final lower = query.toLowerCase();
    return logs.where((entry) {
      final matchesQuery =
          lower.isEmpty ||
          entry.number.toLowerCase().contains(lower) ||
          entry.note.toLowerCase().contains(lower);
      final matchesFilter = filter == null || entry.type == filter;
      return matchesQuery && matchesFilter;
    }).toList();
  }

  void load() {
    enabled = storage.setting('protectionEnabled', true);
    logs
      ..clear()
      ..addAll(storage.callLogs());
    _refreshDialerState();
    notifyListeners();
  }

  Future<void> _refreshDialerState() async {
    defaultDialer = await callService.isDefaultDialer();
    notifyListeners();
  }

  Future<void> setEnabled(bool value) async {
    enabled = value;
    await storage.setSetting('protectionEnabled', value);
    notifyListeners();
  }

  Future<void> simulateIncomingCall({
    required String number,
    required NumbersProvider numbers,
    required ResponderProvider responder,
    required SettingsProvider settings,
  }) async {
    final decision = callService.evaluate(
      number: number,
      protectionEnabled: enabled,
      blacklist: numbers.blacklist.map((item) => item.number).toList(),
      whitelist: numbers.whitelist.map((item) => item.number).toList(),
      blockedPrefixes: numbers.blockedPrefixes,
      insideAllowedHours: settings.insideAllowedHours,
    );
    final entry = CallLogEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      date: DateTime.now(),
      number: number.isEmpty ? 'Masque' : number,
      type: decision.type,
      action: defaultDialer ? decision.action : CallAction.notified,
      messageUsed: responder.selectedMessage.title,
      scenarioUsed:
          '${responder.selectedScenario.name} - ${responder.selectedScenarioLine}',
      estimatedDurationSeconds: settings.hangupDelaySeconds,
      note: defaultDialer
          ? decision.explanation
          : 'Alternative manuelle : notification, script et bouton raccrocher.',
    );
    await storage.saveLog(entry);
    if (settings.notificationsEnabled) {
      try {
        await notifications.showIncomingAlert(entry.number, entry.action.label);
      } catch (_) {
        // La simulation reste valide meme si Android bloque les notifications.
      }
    }
    logs.insert(0, entry);
    notifyListeners();
  }

  Future<void> updateNote(CallLogEntry entry, String note) async {
    await storage.saveLog(entry.copyWith(note: note));
    load();
  }

  Future<void> clearLogs() async {
    await storage.clearLogs();
    load();
  }

  Future<bool> requestDefaultDialer() async {
    final opened = await callService.requestDefaultDialerRole();
    await _refreshDialerState();
    return opened;
  }

  Future<void> refreshDialerState() => _refreshDialerState();

  Future<bool> openDefaultAppsSettings() async {
    return callService.openDefaultAppsSettings();
  }

  void setQuery(String value) {
    query = value;
    notifyListeners();
  }

  void setFilter(CallType? value) {
    filter = value;
    notifyListeners();
  }
}

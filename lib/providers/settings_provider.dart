import 'package:flutter/material.dart';

import '../models/call_types.dart';
import '../services/native_rules_service.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this.storage);

  final StorageService storage;

  ThemeMode themeMode = ThemeMode.system;
  bool notificationsEnabled = true;
  bool responderEnabled = true;
  bool pinEnabled = false;
  bool blockHiddenNumbers = true;
  int hangupDelaySeconds = 25;
  TimeOfDay start = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay end = const TimeOfDay(hour: 20, minute: 0);
  AiTone defaultTone = AiTone.funny;

  void load() {
    themeMode =
        ThemeMode.values[storage.setting('themeMode', ThemeMode.system.index)];
    notificationsEnabled = storage.setting('notificationsEnabled', true);
    responderEnabled = storage.setting('responderEnabled', true);
    pinEnabled = storage.setting('pinEnabled', false);
    blockHiddenNumbers = storage.setting('blockHiddenNumbers', true);
    hangupDelaySeconds = storage.setting('hangupDelaySeconds', 25);
    start = TimeOfDay(
      hour: storage.setting('startHour', 8),
      minute: storage.setting('startMinute', 0),
    );
    end = TimeOfDay(
      hour: storage.setting('endHour', 20),
      minute: storage.setting('endMinute', 0),
    );
    defaultTone = AiTone.fromName(
      storage.setting('defaultTone', AiTone.funny.name),
    );
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode value) async {
    themeMode = value;
    await storage.setSetting('themeMode', value.index);
    notifyListeners();
  }

  Future<void> setNotifications(bool value) async {
    notificationsEnabled = value;
    await storage.setSetting('notificationsEnabled', value);
    notifyListeners();
  }

  Future<void> setResponder(bool value) async {
    responderEnabled = value;
    await storage.setSetting('responderEnabled', value);
    notifyListeners();
  }

  Future<void> setPin(bool value) async {
    pinEnabled = value;
    await storage.setSetting('pinEnabled', value);
    notifyListeners();
  }

  Future<void> setBlockHiddenNumbers(bool value) async {
    blockHiddenNumbers = value;
    await storage.setSetting('blockHiddenNumbers', value);
    await NativeRulesService.sync(storage);
    notifyListeners();
  }

  Future<void> setHangupDelay(int value) async {
    hangupDelaySeconds = value;
    await storage.setSetting('hangupDelaySeconds', value);
    notifyListeners();
  }

  Future<void> setTone(AiTone value) async {
    defaultTone = value;
    await storage.setSetting('defaultTone', value.name);
    notifyListeners();
  }

  Future<void> setHours(TimeOfDay startValue, TimeOfDay endValue) async {
    start = startValue;
    end = endValue;
    await storage.setSetting('startHour', start.hour);
    await storage.setSetting('startMinute', start.minute);
    await storage.setSetting('endHour', end.hour);
    await storage.setSetting('endMinute', end.minute);
    notifyListeners();
  }

  bool get insideAllowedHours {
    final now = TimeOfDay.now();
    final current = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return current >= startMinutes && current <= endMinutes;
  }
}

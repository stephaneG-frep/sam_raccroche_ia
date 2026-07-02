import 'package:flutter/foundation.dart';

import '../models/allowed_number.dart';
import '../models/blocked_number.dart';
import '../services/storage_service.dart';

class NumbersProvider extends ChangeNotifier {
  NumbersProvider(this.storage);

  final StorageService storage;
  final List<BlockedNumber> blacklist = [];
  final List<AllowedNumber> whitelist = [];
  final List<String> blockedPrefixes = ['089', '097', '+339'];

  void load() {
    blacklist
      ..clear()
      ..addAll(storage.blockedNumbers());
    whitelist
      ..clear()
      ..addAll(storage.allowedNumbers());
    blockedPrefixes
      ..clear()
      ..addAll(
        List<String>.from(
          storage.setting('blockedPrefixes', ['089', '097', '+339']),
        ),
      );
    notifyListeners();
  }

  Future<void> addBlocked(String number, String label, String reason) async {
    final item = BlockedNumber(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      number: number,
      label: label,
      reason: reason,
      createdAt: DateTime.now(),
    );
    await storage.saveBlocked(item);
    load();
  }

  Future<void> addAllowed(String number, String label) async {
    final item = AllowedNumber(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      number: number,
      label: label,
      createdAt: DateTime.now(),
    );
    await storage.saveAllowed(item);
    load();
  }

  Future<void> deleteBlocked(String id) async {
    await storage.deleteBlocked(id);
    load();
  }

  Future<void> deleteAllowed(String id) async {
    await storage.deleteAllowed(id);
    load();
  }

  Future<void> addPrefix(String prefix) async {
    if (prefix.trim().isEmpty || blockedPrefixes.contains(prefix.trim())) {
      return;
    }
    blockedPrefixes.add(prefix.trim());
    await storage.setSetting('blockedPrefixes', blockedPrefixes);
    notifyListeners();
  }

  Future<void> removePrefix(String prefix) async {
    blockedPrefixes.remove(prefix);
    await storage.setSetting('blockedPrefixes', blockedPrefixes);
    notifyListeners();
  }
}

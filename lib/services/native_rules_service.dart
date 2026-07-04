import 'dart:convert';

import 'package:flutter/services.dart';

import 'storage_service.dart';

class NativeRulesService {
  static const _channel = MethodChannel('sam_raccroche_ia/calls');

  static Future<void> sync(StorageService storage) async {
    final payload = {
      'settings': {
        'protectionEnabled': storage.setting('protectionEnabled', true),
        'blockedPrefixes': List<String>.from(
          storage.setting('blockedPrefixes', ['089', '097', '+339']),
        ),
      },
      'blacklist': storage.blockedNumbers().map((item) => item.number).toList(),
      'whitelist': storage.allowedNumbers().map((item) => item.number).toList(),
    };

    try {
      await _channel.invokeMethod<void>('syncRules', {
        'payload': jsonEncode(payload),
      });
    } on PlatformException {
      // La protection Flutter reste utilisable meme si le pont natif est indisponible.
    }
  }
}

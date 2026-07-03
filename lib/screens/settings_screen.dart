import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/call_types.dart';
import '../providers/protection_provider.dart';
import '../providers/responder_provider.dart';
import '../providers/settings_provider.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Parametres')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text('Auto'),
                icon: Icon(Icons.brightness_auto),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('Clair'),
                icon: Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('Sombre'),
                icon: Icon(Icons.dark_mode_outlined),
              ),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (value) => settings.setThemeMode(value.first),
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            value: settings.notificationsEnabled,
            onChanged: settings.setNotifications,
          ),
          SwitchListTile(
            title: const Text('Repondeur actif'),
            value: settings.responderEnabled,
            onChanged: settings.setResponder,
          ),
          SwitchListTile(
            title: const Text('Protection par PIN'),
            subtitle: const Text(
              'MVP : preference locale, extensible avec local_auth.',
            ),
            value: settings.pinEnabled,
            onChanged: settings.setPin,
          ),
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: const Text('Delai avant raccrochage'),
            subtitle: Slider(
              min: 5,
              max: 60,
              divisions: 11,
              label: '${settings.hangupDelaySeconds}s',
              value: settings.hangupDelaySeconds.toDouble(),
              onChanged: (value) => settings.setHangupDelay(value.round()),
            ),
            trailing: Text('${settings.hangupDelaySeconds}s'),
          ),
          DropdownButtonFormField<AiTone>(
            initialValue: settings.defaultTone,
            decoration: const InputDecoration(
              labelText: 'Scenario IA par defaut',
            ),
            items: AiTone.values
                .map(
                  (tone) =>
                      DropdownMenuItem(value: tone, child: Text(tone.label)),
                )
                .toList(),
            onChanged: (value) async {
              if (value == null) return;
              await settings.setTone(value);
              if (context.mounted) {
                await context.read<ResponderProvider>().selectTone(value);
              }
            },
          ),
          const Divider(),
          FilledButton.icon(
            onPressed: () => _clearData(context),
            icon: const Icon(Icons.delete_forever_outlined),
            label: const Text('Supprimer toutes les donnees'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearData(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tout supprimer ?'),
        content: const Text(
          'Listes, journal, messages et reglages locaux seront effaces.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      await context.read<StorageService>().clearAll();
      if (context.mounted) {
        context.read<ProtectionProvider>().load();
        context.read<SettingsProvider>().load();
      }
    }
  }
}

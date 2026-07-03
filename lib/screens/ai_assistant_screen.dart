import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/call_types.dart';
import '../providers/responder_provider.dart';
import '../providers/settings_provider.dart';

class AiAssistantScreen extends StatelessWidget {
  const AiAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ResponderProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Assistant IA anti-demarchage')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<AiTone>(
            segments: AiTone.values
                .map(
                  (tone) => ButtonSegment(value: tone, label: Text(tone.label)),
                )
                .toList(),
            selected: {provider.selectedScenario.tone},
            onSelectionChanged: (values) async {
              final tone = values.first;
              final settings = context.read<SettingsProvider>();
              final messenger = ScaffoldMessenger.of(context);
              await provider.selectTone(tone);
              await settings.setTone(tone);
              messenger.showSnackBar(
                SnackBar(
                  content: Text('${tone.label} devient le scenario actif.'),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: Text('Scenario actif : ${provider.selectedScenario.name}'),
              subtitle: Text(provider.selectedScenarioLine),
            ),
          ),
          const SizedBox(height: 8),
          ...provider.selectedScenario.lines.asMap().entries.map(
            (entry) => Card(
              child: ListTile(
                leading: Icon(
                  entry.key == provider.selectedScenario.selectedLineIndex
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                title: Text(entry.value),
                subtitle:
                    entry.key == provider.selectedScenario.selectedLineIndex
                    ? const Text('Phrase active')
                    : null,
                onTap: () async {
                  await provider.selectScenarioLine(entry.key);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Phrase active mise a jour.'),
                      ),
                    );
                  }
                },
                trailing: IconButton(
                  icon: const Icon(Icons.volume_up_outlined),
                  onPressed: () => provider.speakLine(entry.value),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Reponse detectee du correspondant',
              hintText: 'Ex: Je vous appelle pour une offre exceptionnelle...',
              border: OutlineInputBorder(),
            ),
            onChanged: provider.setDetectedResponse,
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.phone_disabled_outlined),
              title: const Text(
                'Alternative si Android bloque l automatisation',
              ),
              subtitle: Text(
                provider.detectedResponse.isEmpty
                    ? 'Afficher le script, lire en haut-parleur manuel, notifier et proposer raccrocher.'
                    : 'Reponse detectee : ${provider.detectedResponse}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

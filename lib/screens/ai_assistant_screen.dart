import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/call_types.dart';
import '../providers/responder_provider.dart';

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
            onSelectionChanged: (values) {
              final scenario = provider.scenarios.firstWhere(
                (item) => item.tone == values.first,
              );
              provider.selectScenario(scenario.id);
            },
          ),
          const SizedBox(height: 16),
          ...provider.selectedScenario.lines.map(
            (line) => Card(
              child: ListTile(
                leading: const Icon(Icons.smart_toy_outlined),
                title: Text(line),
                trailing: IconButton(
                  icon: const Icon(Icons.volume_up_outlined),
                  onPressed: () => provider.speakLine(line),
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

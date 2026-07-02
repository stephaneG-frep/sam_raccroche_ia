import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/responder_provider.dart';
import '../utils/root_navigation.dart';
import '../widgets/section_header.dart';

class ResponderScreen extends StatelessWidget {
  const ResponderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ResponderProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Menu',
          icon: const Icon(Icons.menu),
          onPressed: openRootDrawer,
        ),
        title: const Text('Repondeur drole'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addMessage(context),
        icon: const Icon(Icons.edit_note_outlined),
        label: const Text('Perso'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader('Message utilise'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.selectedMessage.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(provider.selectedMessage.text),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: provider.previewSelectedMessage,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Ecouter'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.mic_outlined),
                        label: const Text('Enregistrer audio'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SectionHeader('Messages predefinis'),
          ...provider.messages.map(
            (message) => ListTile(
              leading: Icon(
                provider.selectedMessageId == message.id
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
              ),
              title: Text(message.title),
              subtitle: Text(
                message.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => provider.selectMessage(message.id),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addMessage(BuildContext context) async {
    final title = TextEditingController();
    final text = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Message personnalise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: text,
              decoration: const InputDecoration(labelText: 'Texte'),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
    if (result == true && context.mounted) {
      await context.read<ResponderProvider>().saveCustomMessage(
        title.text,
        text.text,
      );
    }
  }
}

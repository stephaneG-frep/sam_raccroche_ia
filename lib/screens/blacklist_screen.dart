import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/numbers_provider.dart';
import 'number_form_screen.dart';

class BlacklistScreen extends StatelessWidget {
  const BlacklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NumbersProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Liste noire')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const NumberFormScreen(allowList: false),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (provider.blacklist.isEmpty)
            const Center(child: Text('Aucun numero bloque.')),
          ...provider.blacklist.map(
            (item) => Card(
              child: ListTile(
                leading: const Icon(Icons.block),
                title: Text(item.number),
                subtitle: Text(
                  [
                    item.label,
                    item.reason,
                  ].where((value) => value.isNotEmpty).join(' - '),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => provider.deleteBlocked(item.id),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Prefixes bloques',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Wrap(
            spacing: 8,
            children: provider.blockedPrefixes
                .map(
                  (prefix) => InputChip(
                    label: Text(prefix),
                    onDeleted: () => provider.removePrefix(prefix),
                  ),
                )
                .toList(),
          ),
          OutlinedButton.icon(
            onPressed: () => _addPrefix(context),
            icon: const Icon(Icons.add),
            label: const Text('Ajouter un prefixe'),
          ),
        ],
      ),
    );
  }

  Future<void> _addPrefix(BuildContext context) async {
    final controller = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Prefixe a bloquer'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Ex: 089'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
    if (value != null && context.mounted) {
      await context.read<NumbersProvider>().addPrefix(value);
    }
  }
}

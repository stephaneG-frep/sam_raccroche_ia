import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/numbers_provider.dart';
import 'number_form_screen.dart';

class WhitelistScreen extends StatelessWidget {
  const WhitelistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NumbersProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Liste blanche')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const NumberFormScreen(allowList: true),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: provider.whitelist.isEmpty
          ? const Center(child: Text('Aucun numero autorise.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.whitelist.length,
              itemBuilder: (context, index) {
                final item = provider.whitelist[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.verified_outlined),
                    title: Text(item.number),
                    subtitle: Text(
                      item.label.isEmpty ? 'Sans libelle' : item.label,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => provider.deleteAllowed(item.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

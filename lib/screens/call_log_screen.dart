import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/call_types.dart';
import '../providers/protection_provider.dart';
import '../services/export_service.dart';
import '../utils/root_navigation.dart';

class CallLogScreen extends StatelessWidget {
  const CallLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProtectionProvider>();
    final logs = provider.filteredLogs;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Menu',
          icon: const Icon(Icons.menu),
          onPressed: openRootDrawer,
        ),
        title: const Text('Journal'),
        actions: [
          IconButton(
            tooltip: 'Exporter CSV',
            icon: const Icon(Icons.download_outlined),
            onPressed: () async {
              final file = await ExportService().exportCallLog(provider.logs);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Export : ${file.path}')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Rechercher numero ou note',
                border: OutlineInputBorder(),
              ),
              onChanged: provider.setQuery,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Tous'),
                  selected: provider.filter == null,
                  onSelected: (_) => provider.setFilter(null),
                ),
                const SizedBox(width: 8),
                ...CallType.values.map(
                  (type) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type.label),
                      selected: provider.filter == type,
                      onSelected: (_) => provider.setFilter(type),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: logs.isEmpty
                ? const Center(child: Text('Aucun evenement pour le moment.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final entry = logs[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.phone_disabled_outlined),
                          title: Text(entry.number),
                          subtitle: Text(
                            '${DateFormat('dd/MM HH:mm').format(entry.date)} - ${entry.type.label} - ${entry.action.label}\n${entry.scenarioUsed} - ${entry.note}',
                          ),
                          isThreeLine: true,
                          trailing: Text('${entry.estimatedDurationSeconds}s'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/call_types.dart';
import '../providers/protection_provider.dart';
import '../utils/root_navigation.dart';
import '../widgets/metric_card.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = context.watch<ProtectionProvider>().logs;
    final counts = <CallType, int>{for (final type in CallType.values) type: 0};
    final byNumber = <String, int>{};
    for (final entry in logs) {
      counts[entry.type] = (counts[entry.type] ?? 0) + 1;
      byNumber[entry.number] = (byNumber[entry.number] ?? 0) + 1;
    }
    final top = byNumber.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxCount = counts.values.fold<int>(
      1,
      (max, value) => value > max ? value : max,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Menu',
          icon: const Icon(Icons.menu),
          onPressed: openRootDrawer,
        ),
        title: const Text('Statistiques'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.45,
            children: [
              MetricCard(
                icon: Icons.history,
                label: 'Evenements',
                value: '${logs.length}',
              ),
              MetricCard(
                icon: Icons.block,
                label: 'Actions blocage',
                value:
                    '${logs.where((e) => e.action == CallAction.blocked).length}',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Par type d appel',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...counts.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(width: 110, child: Text(entry.key.label)),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: entry.value / maxCount,
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${entry.value}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Numeros les plus frequents',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ...top
              .take(5)
              .map(
                (entry) => ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(entry.key),
                  trailing: Text('${entry.value}'),
                ),
              ),
        ],
      ),
    );
  }
}

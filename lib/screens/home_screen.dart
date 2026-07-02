import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/numbers_provider.dart';
import '../providers/protection_provider.dart';
import '../providers/responder_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/root_navigation.dart';
import '../widgets/metric_card.dart';
import '../widgets/section_header.dart';
import 'ai_assistant_screen.dart';
import 'blacklist_screen.dart';
import 'call_log_screen.dart';
import 'permissions_screen.dart';
import 'responder_screen.dart';
import 'settings_screen.dart';
import 'stats_screen.dart';
import 'whitelist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  static const _screens = [
    _DashboardView(),
    ResponderScreen(),
    CallLogScreen(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: rootScaffoldKey,
      body: SafeArea(child: _screens[_index]),
      drawer: const _AppDrawer(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.record_voice_over_outlined),
            selectedIcon: Icon(Icons.record_voice_over),
            label: 'Repondeur',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Journal',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 24, 16, 12),
          child: Text('Sam Raccroche IA'),
        ),
        _drawerTile(
          context,
          Icons.block_outlined,
          'Liste noire',
          const BlacklistScreen(),
        ),
        _drawerTile(
          context,
          Icons.verified_outlined,
          'Liste blanche',
          const WhitelistScreen(),
        ),
        _drawerTile(
          context,
          Icons.smart_toy_outlined,
          'Assistant IA',
          const AiAssistantScreen(),
        ),
        _drawerTile(
          context,
          Icons.admin_panel_settings_outlined,
          'Permissions Android',
          const PermissionsScreen(),
        ),
        _drawerTile(
          context,
          Icons.settings_outlined,
          'Parametres',
          const SettingsScreen(),
        ),
      ],
    );
  }

  Widget _drawerTile(
    BuildContext context,
    IconData icon,
    String label,
    Widget screen,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
      },
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final protection = context.watch<ProtectionProvider>();
    final numbers = context.watch<NumbersProvider>();
    final responder = context.watch<ResponderProvider>();
    final settings = context.watch<SettingsProvider>();
    final logs = protection.logs;
    final now = DateTime.now();
    final today = logs
        .where(
          (entry) =>
              entry.date.year == now.year &&
              entry.date.month == now.month &&
              entry.date.day == now.day,
        )
        .length;
    final week = logs
        .where((entry) => now.difference(entry.date).inDays < 7)
        .length;
    final month = logs
        .where(
          (entry) =>
              entry.date.year == now.year && entry.date.month == now.month,
        )
        .length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Menu',
          icon: const Icon(Icons.menu),
          onPressed: openRootDrawer,
        ),
        title: const Text('Sam Raccroche IA'),
        actions: [
          Switch(value: protection.enabled, onChanged: protection.setEnabled),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: protection.enabled
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  protection.enabled
                      ? Icons.security
                      : Icons.security_update_warning,
                  size: 42,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        protection.enabled
                            ? 'Protection active'
                            : 'Protection en pause',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        protection.defaultDialer
                            ? 'Mode Android avance disponible.'
                            : 'Mode alternatif : notifications, script et actions manuelles.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SectionHeader('Tableau de bord'),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.45,
            children: [
              MetricCard(
                icon: Icons.today,
                label: 'Bloques aujourd hui',
                value: '$today',
              ),
              MetricCard(
                icon: Icons.calendar_view_week,
                label: 'Cette semaine',
                value: '$week',
              ),
              MetricCard(
                icon: Icons.calendar_month,
                label: 'Ce mois',
                value: '$month',
              ),
              MetricCard(
                icon: Icons.block,
                label: 'Numeros listes',
                value:
                    '${numbers.blacklist.length}/${numbers.whitelist.length}',
              ),
            ],
          ),
          const SectionHeader(
            'Simulation MVP',
            subtitle: 'Permet de tester le comportement sans appel reel.',
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                icon: const Icon(Icons.phone_callback),
                label: const Text('Simuler suspect'),
                onPressed: () async {
                  await protection.simulateIncomingCall(
                    number: '0970123456',
                    numbers: numbers,
                    responder: responder,
                    settings: settings,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Appel suspect simule et ajoute au journal.',
                        ),
                      ),
                    );
                  }
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.phone_disabled),
                label: const Text('Simuler masque'),
                onPressed: () async {
                  await protection.simulateIncomingCall(
                    number: '',
                    numbers: numbers,
                    responder: responder,
                    settings: settings,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Appel masque simule et ajoute au journal.',
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const SectionHeader('Action conseillee'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.smart_toy_outlined),
              title: Text(responder.selectedScenario.name),
              subtitle: Text(responder.selectedScenario.firstLine),
            ),
          ),
          if (!protection.defaultDialer)
            const Card(
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Limite Android moderne'),
                subtitle: Text(
                  'Repondre, diffuser un son dans l appel ou raccrocher peut exiger que l app soit telephone par defaut. Les alternatives manuelles restent disponibles.',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

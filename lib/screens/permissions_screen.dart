import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/protection_provider.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final protection = context.watch<ProtectionProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions Android')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Android limite fortement la reponse automatique, la diffusion audio dans un appel et le raccrochage. Sam utilise le role filtrage d appels pour ne pas remplacer l app Telephone. Si Sam a ete choisi comme telephone par defaut, remettez votre app Telephone habituelle dans les parametres Android.',
              ),
            ),
          ),
          _PermissionTile(
            title: 'Etat telephone',
            permission: Permission.phone,
          ),
          _PermissionTile(title: 'Contacts', permission: Permission.contacts),
          _PermissionTile(
            title: 'Microphone',
            permission: Permission.microphone,
          ),
          _PermissionTile(
            title: 'Notifications',
            permission: Permission.notification,
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(
                protection.defaultDialer
                    ? Icons.check_circle_outline
                    : Icons.info_outline,
              ),
              title: const Text('Etat filtrage appels'),
              subtitle: Text(
                protection.defaultDialer
                    ? 'Sam peut filtrer les appels sans remplacer le telephone.'
                    : 'Sam n a pas encore le role filtrage d appels sur cet appareil.',
              ),
              trailing: IconButton(
                tooltip: 'Rafraichir',
                icon: const Icon(Icons.refresh),
                onPressed: protection.refreshDialerState,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () async {
              final opened = await protection.requestDefaultDialer();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      opened
                          ? 'Demande Android ouverte. Choisissez Sam pour le filtrage d appels, pas comme telephone par defaut.'
                          : 'Android n a pas ouvert la demande. Utilisez les parametres des apps par defaut.',
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.phone_android_outlined),
            label: Text(
              protection.defaultDialer
                  ? 'Filtrage appels actif'
                  : 'Activer le filtrage appels',
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              final opened = await protection.openDefaultAppsSettings();
              if (!opened && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Impossible d ouvrir les parametres Android automatiquement.',
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.settings_applications_outlined),
            label: const Text('Ouvrir apps par defaut'),
          ),
        ],
      ),
    );
  }
}

class _PermissionTile extends StatefulWidget {
  const _PermissionTile({required this.title, required this.permission});

  final String title;
  final Permission permission;

  @override
  State<_PermissionTile> createState() => _PermissionTileState();
}

class _PermissionTileState extends State<_PermissionTile> {
  PermissionStatus? status;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final value = await widget.permission.status;
    if (mounted) setState(() => status = value);
  }

  @override
  Widget build(BuildContext context) {
    final granted = status?.isGranted ?? false;
    return Card(
      child: ListTile(
        leading: Icon(
          granted ? Icons.check_circle_outline : Icons.error_outline,
        ),
        title: Text(widget.title),
        subtitle: Text(status?.name ?? 'Inconnu'),
        trailing: OutlinedButton(
          onPressed: () async {
            await widget.permission.request();
            await _refresh();
          },
          child: const Text('Demander'),
        ),
      ),
    );
  }
}

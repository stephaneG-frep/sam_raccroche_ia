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
                'Android limite fortement la reponse automatique, la diffusion audio dans un appel et le raccrochage. Pour certaines actions, l application doit etre telephone par defaut. Sinon Sam propose notifications, bouton Lire message, script a lire et mode haut-parleur manuel.',
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
          FilledButton.icon(
            onPressed: protection.requestDefaultDialer,
            icon: const Icon(Icons.phone_android_outlined),
            label: Text(
              protection.defaultDialer
                  ? 'Telephone par defaut actif'
                  : 'Definir comme telephone par defaut',
            ),
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

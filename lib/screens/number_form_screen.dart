import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/numbers_provider.dart';

class NumberFormScreen extends StatefulWidget {
  const NumberFormScreen({super.key, required this.allowList});

  final bool allowList;

  @override
  State<NumberFormScreen> createState() => _NumberFormScreenState();
}

class _NumberFormScreenState extends State<NumberFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _number = TextEditingController();
  final _label = TextEditingController();
  final _reason = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.allowList
              ? 'Ajouter en liste blanche'
              : 'Ajouter en liste noire',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _number,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Numero ou indicatif',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Numero obligatoire'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _label,
              decoration: const InputDecoration(
                labelText: 'Nom ou libelle',
                border: OutlineInputBorder(),
              ),
            ),
            if (!widget.allowList) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _reason,
                decoration: const InputDecoration(
                  labelText: 'Raison',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<NumbersProvider>();
    if (widget.allowList) {
      await provider.addAllowed(_number.text.trim(), _label.text.trim());
    } else {
      await provider.addBlocked(
        _number.text.trim(),
        _label.text.trim(),
        _reason.text.trim(),
      );
    }
    if (mounted) Navigator.pop(context);
  }
}

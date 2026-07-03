import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aide')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _HelpCard(
            icon: Icons.play_circle_outline,
            title: 'Demarrage rapide',
            lines: [
              '1. Activez la protection depuis l accueil.',
              '2. Ajoutez les numeros connus dans Liste blanche.',
              '3. Ajoutez les indesirables dans Liste noire.',
              '4. Choisissez un message dans Repondeur.',
              '5. Choisissez un mode et une phrase dans Assistant IA.',
            ],
          ),
          _HelpCard(
            icon: Icons.smart_toy_outlined,
            title: 'Choisir le scenario IA',
            lines: [
              'Ouvrez Assistant IA.',
              'Choisissez le ton : Drole, Poli, Tres sec ou Absurde.',
              'Touchez ensuite la phrase exacte a utiliser.',
              'La phrase cochee devient active pour les simulations et le journal.',
              'Le bouton haut-parleur permet d ecouter la phrase.',
            ],
          ),
          _HelpCard(
            icon: Icons.phone_android_outlined,
            title: 'Telephone par defaut',
            lines: [
              'Android peut refuser le role telephone si l app n est pas assez complete.',
              'L ecran Permissions permet de tenter le role et de verifier l etat.',
              'Si Android refuse, utilisez le mode alternatif.',
              'Le mode alternatif garde les notifications, scripts et lecture vocale.',
            ],
          ),
          _HelpCard(
            icon: Icons.call_missed_outgoing,
            title: 'Simuler un appel',
            lines: [
              'Depuis l accueil, utilisez Simuler suspect ou Simuler masque.',
              'Un evenement est ajoute au journal.',
              'Le scenario et la phrase active sont enregistres dans l entree.',
              'Cela permet de tester sans recevoir un vrai appel.',
            ],
          ),
          _HelpCard(
            icon: Icons.record_voice_over_outlined,
            title: 'Repondeur drole',
            lines: [
              'Choisissez un message predefini ou creez un message personnel.',
              'Utilisez Ecouter pour lancer la synthese vocale Android.',
              'Sur Android, diffuser automatiquement dans l appel peut etre bloque.',
              'Dans ce cas, utilisez le mode haut-parleur manuel.',
            ],
          ),
          _HelpCard(
            icon: Icons.history_outlined,
            title: 'Journal et export',
            lines: [
              'Le journal liste chaque evenement simule ou detecte.',
              'Vous pouvez filtrer par type et rechercher par numero ou note.',
              'Le bouton export cree un fichier CSV local.',
            ],
          ),
        ],
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({
    required this.icon,
    required this.title,
    required this.lines,
  });

  final IconData icon;
  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...lines.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(line),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

# Sam Raccroche IA

MVP Flutter Android anti-demarchage avec repondeur humoristique local.

## Inclus

- Protection activable/desactivable
- Listes noire et blanche
- Blocage par prefixes et horaires
- Journal des appels avec filtres et export CSV
- Tableau de bord et statistiques simples
- Repondeur drole avec synthese vocale Android
- Assistant IA anti-demarchage avec modes drole, poli, tres sec et absurde
- Ecran permissions Android
- MethodChannel Flutter/Kotlin pour preparer les fonctions telephone natives
- Alternatives propres quand Android exige l app telephone par defaut

## Limites Android

Android moderne ne permet pas toujours de repondre automatiquement, diffuser un son dans l appel ou raccrocher, sauf role telephone par defaut et API compatibles. Le MVP affiche cette limite et propose notification, script a lire, bouton de lecture TTS et action manuelle.

## Mode d'emploi rapide

1. Activez la protection depuis l'accueil.
2. Ajoutez les numeros surs en liste blanche.
3. Ajoutez les indesirables ou prefixes en liste noire.
4. Choisissez un message dans Repondeur.
5. Dans Assistant IA, choisissez un ton puis la phrase exacte a utiliser.
6. Testez avec Simuler suspect ou Simuler masque.
7. Consultez le journal et exportez-le en CSV si besoin.

## Lancer

```bash
flutter pub get
flutter run
```

## Build Android

```bash
flutter build apk --debug
flutter build apk --release
```

Pour une signature Android de diffusion, voir [SIGNING.md](SIGNING.md).

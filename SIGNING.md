# Signature Android

Le projet peut produire une APK release de test sans configuration supplementaire.
Pour une vraie signature de diffusion, creez une cle locale non versionnee.

## Creer une cle

```bash
keytool -genkeypair -v \
  -keystore android/sam-raccroche-upload-key.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias sam-raccroche
```

## Creer `android/key.properties`

```properties
storePassword=VOTRE_MOT_DE_PASSE_STORE
keyPassword=VOTRE_MOT_DE_PASSE_CLE
keyAlias=sam-raccroche
storeFile=sam-raccroche-upload-key.jks
```

Ces fichiers sont ignores par Git.

## Build release

```bash
flutter build apk --release
```

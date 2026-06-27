<div align="center">

# Aura · Estates
[![Live Demo](https://img.shields.io/badge/Présentation-Live%20Demo-C9A96E?style=for-the-badge)](https://ton-username.github.io/aura_estates/)

> 🔗 **[Voir la présentation interactive →](https://Anas121.github.io/aura_estates/)**
**Plateforme de gestion immobilière haut de gamme**  
Application mobile client + panel d'administration web — architecture monorepo Flutter / Firebase

[![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore%20%7C%20Auth%20%7C%20Storage-FFCA28?logo=firebase)](https://firebase.google.com)
[![Riverpod](https://img.shields.io/badge/Riverpod-3.x-00B4D8)](https://riverpod.dev)
[![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web-brightgreen)]()

</div>

---

## Aperçu

Aura Estates est une solution complète de gestion immobilière destinée aux agences de luxe.  
Le projet se compose de **deux applications Flutter** partageant la même logique métier via un **package Dart interne** :

| App | Cible | Description |
|---|---|---|
| `apps/mobile` | Clients | Parcourir les propriétés, envoyer des demandes de visite |
| `apps/admin` | Agents / Admin | Panel web de gestion : propriétés, réservations, dashboard |
| `packages/aura_estates_core` | Partagé | Modèles, repositories, controllers, thème |

---

## Fonctionnalités

### Application mobile (client)
- Catalogue de propriétés avec filtres par catégorie
- Fiches détaillées (photos, surface, chambres, localisation)
- Formulaire de demande de réservation
- Authentification Firebase (email / mot de passe)
- Mise à jour temps réel via Firestore streams

### Panel admin (web)
- **Dashboard** — statistiques en temps réel (nb propriétés, réservations, statuts)
- **Gestion des propriétés** — CRUD complet avec upload d'image (Firebase Storage)
- **Gestion des réservations** — confirmation / annulation / suppression avec dialogs de confirmation
- Synchronisation temps réel sur toutes les vues

---

## Stack technique

| Couche | Technologie | Rôle |
|---|---|---|
| UI | Flutter 3.24+ | Applications mobile & web depuis un seul codebase |
| State management | Riverpod 3 + `riverpod_annotation` | Providers générés, streams réactifs, controllers |
| Navigation | Go Router | Navigation déclarative, guards d'authentification |
| Backend | Firebase Firestore | Base de données NoSQL temps réel |
| Auth | Firebase Authentication | Gestion des sessions utilisateur |
| Fichiers | Firebase Storage | Upload et hébergement des images |
| Fonts | Google Fonts | Cormorant Garamond (titres) + Jost (corps) |
| Code gen | `build_runner` | Génération des providers Riverpod et sérialisation |

---

## Architecture

### Structure monorepo

```
aura_estates/
├── apps/
│   ├── admin/          # Flutter Web — panel administrateur
│   │   └── lib/
│   │       ├── core/router/        # Go Router + guards
│   │       └── features/pages/     # Dashboard, Propriétés, Réservations
│   └── mobile/         # Flutter Android/iOS — app client
│       └── lib/
│           └── features/           # Catalogue, Détail, Réservation, Auth
└── packages/
    └── aura_estates_core/          # Package partagé
        └── lib/src/
            ├── models/             # PropertyModel, BookingModel
            ├── repositories/       # Accès Firestore & Storage
            ├── controllers/        # Logique métier (Riverpod Notifiers)
            └── theme/              # AppColors, AppTheme
```

### Pattern Repository / Controller / Provider

```
UI (Widget)
  └── ref.watch(propertiesStreamProvider)        ← stream temps réel
        └── PropertyRepository.watchProperties()  ← Firestore snapshots
  
  └── ref.read(propertyControllerProvider)
        └── PropertyController.addPropertyWithImage()
              ├── StorageRepository.uploadImage()  ← Firebase Storage
              └── PropertyRepository.addProperty() ← Firestore write
```

Chaque couche a une responsabilité unique :
- **Model** — structure de données + sérialisation Firestore
- **Repository** — accès aux données (Firestore / Storage), aucune logique métier
- **Controller** — orchestration des opérations, gestion des états (`AsyncLoading / AsyncData / AsyncError`)
- **Provider** — exposition réactive à l'UI via Riverpod

---

## Problèmes techniques résolus

### 1. Compatibilité image Flutter Web
`Image.file()` ne fonctionne pas sur Flutter Web (pas d'accès au système de fichiers natif).

**Solution** — utilisation de `XFile.readAsBytes()` pour lire l'image en `Uint8List`, puis `Image.memory()` pour l'affichage. Compatible mobile, web et desktop sans conditionnel.

```dart
// ❌ Mobile uniquement
Image.file(File(xfile.path))

// ✅ Toutes plateformes
final bytes = await xfile.readAsBytes();
Image.memory(bytes)
```

### 2. Crash Firebase Web — `jsObject as JSObject`
Sur Flutter Web, si un listener Firestore est attaché avant que le SDK Firebase JS soit pleinement initialisé, `jsObject` est `null` → crash au cast.

**Solution** — remplacement du champ `final` par un getter lazy sur `CollectionReference`. L'instance Firestore n'est accédée qu'au moment de l'appel, pas à l'instanciation du repository.

```dart
// ❌ Évalué trop tôt, avant que Firebase soit prêt
final _collection = FirebaseFirestore.instance.collection('properties');

// ✅ Évalué au moment de l'appel uniquement
CollectionReference<Map<String, dynamic>> get _collection =>
    FirebaseFirestore.instance.collection('properties');
```

### 3. Riverpod — `Ref used after dispose`
En Riverpod 3, `AsyncValue.guard()` + `ref.keepAlive()` dans les méthodes d'un `Notifier` provoque un crash si le provider est disposé pendant un `await` (navigation, rebuild).

**Solution** — pattern `try/catch` + `ref.mounted` sur chaque assignation de `state` après un gap asynchrone.

```dart
// ❌ Crash si le provider est disposé pendant l'await
state = await AsyncValue.guard(() async {
  await repository.doSomething();
});

// ✅ Vérifie que le provider existe toujours avant d'écrire
try {
  await repository.doSomething();
  if (ref.mounted) state = const AsyncData(null);
} catch (e, st) {
  if (ref.mounted) state = AsyncError(e, st);
}
```

### 4. Layout Flutter — double scroll
Un `ListView` imbriqué dans un `SingleChildScrollView` sans contrainte de hauteur provoque une erreur de layout ("unbounded height").

**Solution** — remplacement du `ListView` interne par une `Column` quand le contenu n'a pas besoin d'être virtualisé, et ajout systématique de `NeverScrollableScrollPhysics()` + `shrinkWrap: true` sur les `ListView` imbriqués.

### 5. Type safety Firestore
Sans typage explicite, `CollectionReference` retourne `Object?` depuis `doc.data()`, incompatible avec `Map<String, dynamic>` attendu par les modèles.

**Solution** — typage explicite du générique sur toutes les références de collection.

```dart
// ✅ doc.data() retourne directement Map<String, dynamic>
CollectionReference<Map<String, dynamic>> get _collection =>
    FirebaseFirestore.instance.collection('properties');
```

---

## Modèles de données

### PropertyModel
```
id, title, price, currency, location, category,
description, imageUrl, bedrooms, bathrooms, area, isFeatured
```

### BookingModel
```
id, userName, userMail, userPhone,
currentProperty (PropertyModel),
bookingDate, status (En attente | Confirmée | Annulée)
```

---

## Installation

### Prérequis
- Flutter 3.24+
- Compte Firebase avec projet configuré
- `flutterfire_cli` installé

```bash
dart pub global activate flutterfire_cli
```

### Configuration Firebase

```bash
flutterfire configure
```

Lance cette commande dans `apps/admin` et `apps/mobile` séparément pour générer les fichiers `firebase_options.dart`.

### Lancement

```bash
# Package partagé
cd packages/aura_estates_core
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Admin web
cd apps/admin
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome

# Mobile
cd apps/mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

---

## Design system

Le projet utilise un design system sombre inspiré de l'immobilier de luxe, centralisé dans `AppColors` :

| Token | Valeur | Usage |
|---|---|---|
| `noir` | `#0C0C0B` | Background principal |
| `surface` | `#141413` | Cartes de premier niveau |
| `surfaceElevee` | `#1E1E1C` | Cartes secondaires, tableaux |
| `bordure` | `#3A3A38` | Séparateurs, bordures |
| `or` | `#C9A96E` | Accent principal, actions |
| `succes` | `#4CAF50` | Statut confirmé |
| `erreur` | `#EF5350` | Statut annulé, suppressions |
| `textPrimaire` | `#F7F4EE` | Texte principal |
| `textSecondaire` | `#9E9E98` | Texte secondaire |
| `textDiscret` | `#6B6B67` | Labels, placeholders |

---

## Auteur

Développé par **Stiti Anas**  
Stack Flutter / Firebase / Riverpod — disponible en freelance

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Profil-0A66C2?logo=linkedin)](https://linkedin.com/in/ton-profil)
[![Email](https://img.shields.io/badge/Contact-stiti.anas%40proton.me-EA4335?logo=gmail)](mailto:stiti.anas@proton.me)

import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/properties_model.dart';
import '../repositories/property_repository.dart';
import '../repositories/storage_repository.dart';

part 'property_controller.g.dart'; // ← Fichier auto-généré par Riverpod (ne pas toucher)

// ─────────────────────────────────────────────
// PARTIE LECTURE — Pour afficher la liste
// L'écran observe ce provider, il se met à jour tout seul
// ─────────────────────────────────────────────

@riverpod
Stream<List<PropertyModel>> propertiesStream(Ref ref) {
  return ref.watch(propertyRepositoryProvider).watchProperties();
}

// ─────────────────────────────────────────────
// PARTIE ÉCRITURE — Pour les actions (boutons)
// Gère le chargement et les erreurs automatiquement
// ─────────────────────────────────────────────

@riverpod
class PropertyController extends _$PropertyController {
  @override
  FutureOr<void> build() {
    // Rien à faire au démarrage, on attend qu'une action soit déclenchée
  }

  // ➕ Ajouter une propriété
  Future<void> addProperty(Map<String, dynamic> currentModel) async {
    // AsyncLoading = "Je suis en train de travailler, patiente..."
    state = const AsyncLoading();

    // AsyncValue.guard = "Essaie, et si ça plante, capture l'erreur"
    state = await AsyncValue.guard(() async {
      await ref.read(propertyRepositoryProvider).addProperty(currentModel);
    });
  }

  // 🗑️ Supprimer une tâche
  Future<void> deleteProperty(String id) async {
    final keepAlive = ref.keepAlive(); // ← manque ici
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(propertyRepositoryProvider).deleteProperty(id);
    });
    keepAlive.close();

    // Pas besoin de rafraîchir manuellement : Firebase met à jour le Stream tout seul ✅
  }

  // ➕ Ajouter une propriété avec Image
  Future<void> addPropertyWithImage({
    required XFile image,
    required Map<String, dynamic> propertyData,
  }) async {
    final keepAlive = ref.keepAlive();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Étape 1 : Envoyer l'image au Hangar, récupérer l'URL
      final String imageUrl = await ref
          .read(storageRepositoryProvider)
          .uploadImage(file: image);

      // Étape 2 : Ranger l'URL dans le Tiroir Firestore
      await ref.read(propertyRepositoryProvider).addProperty({
        ...propertyData,
        'imageUrl': imageUrl, // Seulement le reçu, jamais le fichier brut
      });
    });
    keepAlive.close();
  }

  Future<void> updatePropertyWithImage({
    required String id,
    required XFile? newImage, // null = garder l'image existante
    required Map<String, dynamic> propertyData,
  }) async {
    final keepAlive = ref.keepAlive();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Nouvelle image choisie → on upload et on récupère la nouvelle URL
      // Pas de nouvelle image → imageUrl existante est déjà dans propertyData
      String? newImageUrl;
      if (newImage != null) {
        newImageUrl = await ref
            .read(storageRepositoryProvider)
            .uploadImage(file: newImage);
      }

      await ref.read(propertyRepositoryProvider).updateProperty(id, {
        ...propertyData,
        if (newImageUrl != null) 'imageUrl': newImageUrl,
      });
    });
    keepAlive.close();
  }
}

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String build() => 'TOUS';

  void select(String category) => state = category;
}

import '../models/properties_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'property_repository.g.dart';

class PropertyRepository {
  CollectionReference<Map<String, dynamic>> get _collection =>
      FirebaseFirestore.instance.collection('properties');

  // Caméra de surveillance : Stream temps réel de tous les véhicules
  Stream<List<PropertyModel>> watchProperties() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => PropertyModel.fromFirestore(doc.data(), doc.id))
          .toList(),
    );
  }

  // Caméra sur UN seul véhicule (pour la page de détail)
  Stream<PropertyModel> watchPropertyUnique(String id) {
    return _collection.doc(id).snapshots().map((doc) {
      if (!doc.exists) throw Exception('propriété introuvable');
      return PropertyModel.fromFirestore(doc.data()!, doc.id);
    });
  }

  // Filtre par catégorie
  Stream<List<PropertyModel>> watchParCategorie(String categorie) {
    return _collection
        .where('categorie', isEqualTo: categorie)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PropertyModel.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  // Ajout d'un véhicule (Admin)
  Future<void> addProperty(Map<String, dynamic> currentModel) async {
    await _collection.add(currentModel);
  }

  Future<void> updateProperty(String id, Map<String, dynamic> data) async {
    await _collection.doc(id).update(data);
  }

  Future<void> deleteProperty(String id) async {
    await _collection.doc(id).delete();
  }
}

// Le badge Riverpod
@riverpod
PropertyRepository propertyRepository(Ref ref) => PropertyRepository();

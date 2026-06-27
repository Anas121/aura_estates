import 'package:aura_estates/features/properties/data/models/user_data.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_controller.g.dart';

const String userDataBoxName = 'user_data';
const String _profileKey =
    'profile'; // un seul utilisateur local → une seule entrée

class UserDataRepository {
  Box<UserData> get _box => Hive.box<UserData>(userDataBoxName);

  UserData read() {
    return _box.get(_profileKey) ??
        UserData(userName: '', userEmail: '', userPhone: '');
  }

  Future<void> save(UserData data) async {
    await _box.put(_profileKey, data);
  }
}

@riverpod
UserDataRepository userDataRepository(Ref ref) => UserDataRepository();

@riverpod
class UserDataController extends _$UserDataController {
  @override
  UserData build() {
    // Lecture synchrone : contrairement à Firestore, Hive garde tout en
    // mémoire une fois la box ouverte — pas besoin d'AsyncValue ici,
    // comme pour ton SelectedCategory.
    return ref.watch(userDataRepositoryProvider).read();
  }

  Future<void> toggleFavorite(String propertyId) async {
    final favorites = Set<String>.from(state.userFavorites);
    favorites.contains(propertyId)
        ? favorites.remove(propertyId)
        : favorites.add(propertyId);

    final updated = UserData(
      userName: state.userName,
      userEmail: state.userEmail,
      userPhone: state.userPhone,
      userFavorites: favorites.toList(),
    );

    await ref.read(userDataRepositoryProvider).save(updated);
    state = updated;
  }
}

@riverpod
bool isFavorite(Ref ref, String propertyId) {
  return ref
      .watch(userDataControllerProvider)
      .userFavorites
      .contains(propertyId);
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Frappe 1 : Connexion
  Future<void> toLogin(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Frappe 2 : Inscription
  Future<void> toSignIn(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Frappe 3 : Éjection
  Future<void> toLogout() async {
    await _auth.signOut();
  }

  // Frappe 4 : Réinitialisation du mot de passe (indispensable en prod)
  Future<void> toResetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Accès à l'utilisateur actuel
  User? get utilisateurActuel => _auth.currentUser;
}

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository();

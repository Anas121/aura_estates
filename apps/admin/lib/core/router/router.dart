import 'package:admin/features/auth/presentation/login_screen.dart';
import 'package:admin/features/pages/dashboard/dashboard_page.dart';
import 'package:admin/features/pages/properties/add_property_page.dart';
import 'package:admin/features/pages/properties/edit_property_page.dart';
import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

// ---------------------------------------------------------
// 1. LE RADAR D'AUTHENTIFICATION
// ---------------------------------------------------------

@riverpod
Stream<User?> authState(Ref ref) {
  return FirebaseAuth.instance.authStateChanges();
}

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
}

@riverpod
GoRouter router(Ref ref) {
  final notifier = RouterNotifier(ref);
  ref.onDispose(() => notifier.dispose());

  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: notifier,

    redirect: (context, state) {
      final authValue = ref.read(authStateProvider);

      if (authValue.isLoading) return null;

      final bool isAuth = authValue.value != null;
      final bool isGoingToLogin = state.matchedLocation == '/login';

      // 1. Intrusion bloquée : Non connecté et tente d'aller ailleurs que le Login
      if (!isAuth && !isGoingToLogin) {
        return '/login';
      }

      // 2. Redondance évitée : Déjà connecté mais tente d'aller sur Login -> Retour au QG
      if (isAuth && isGoingToLogin) {
        return '/dashboard';
      }

      // 3. Passage autorisé
      return null;
    },

    routes: [
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: 'dashboard',
        path: '/dashboard',
        builder: (context, state) => const DashboardPage(),
        routes: [
          GoRoute(
            name: 'add_property',
            path: 'add_property', // Pas de '/' au début pour les sous-routes
            builder: (context, state) => const AddPropertyPage(),
          ),
          GoRoute(
            name: 'edit_property',
            path: '/edit_property',

            builder: (context, state) {
              final PropertyModel currentProperty =
                  state.extra as PropertyModel;
              return EditPropertyPage(property: currentProperty);
            },
          ),
        ],
      ),
    ],
  );
}

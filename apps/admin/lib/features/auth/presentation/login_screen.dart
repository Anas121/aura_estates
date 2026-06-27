import 'package:admin/features/auth/controllers/auth_controller.dart';
import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Traduction des codes d'erreur Firebase en messages humains
  String _traduireErreur(Object error) {
    final code = error.toString();
    if (code.contains('user-not-found'))
      return 'Aucun compte associé à cet email.';
    if (code.contains('wrong-password')) return 'Mot de passe incorrect.';
    if (code.contains('too-many-requests'))
      return 'Trop de tentatives. Réessayez plus tard.';
    if (code.contains('network-request-failed'))
      return 'Vérifiez votre connexion internet.';
    return 'Échec d\'identification. Vérifiez vos identifiants.';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    // Surveillance silencieuse des erreurs
    ref.listen<AsyncValue>(authControllerProvider, (_, state) {
      if (!state.isLoading && state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_traduireErreur(state.error!)),
            backgroundColor: AppColors.erreur,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.noir,
      body: Row(
        children: [
          Expanded(flex: 1, child: const SizedBox()),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo / Identité
                Text(
                  'Aura Estates'.toUpperCase(),
                  style: GoogleFonts.jost(
                    color: AppColors.or,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 48),

                // Champs de saisie
                MyTextfield(
                  label: 'Email',
                  controller: _emailController,
                  typeClavier: TextInputType.emailAddress,
                  icone: Icons.person,
                ),
                const SizedBox(height: 16),
                MyTextfield(
                  label: 'Mot de passe',
                  controller: _passwordController,
                  isPassword: true,
                  icone: Icons.password,
                ),
                const SizedBox(height: 32),

                // Bouton massif
                ElevatedButton(
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          ref
                              .read(authControllerProvider.notifier)
                              .login(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );
                        },
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.noir,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "S'AUTHENTIFIER",
                              style: TextStyle(
                                letterSpacing: 1.5,
                                color: AppColors.noir2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: AppColors.noir2,
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
          Expanded(flex: 1, child: const SizedBox()),
        ],
      ),
    );
  }
}

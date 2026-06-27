import 'package:admin/core/router/router.dart'; // Pour ton authStateProvider
import 'package:admin/features/auth/controllers/auth_controller.dart';
import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: AppColors.noir2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Zone 1 : Header ──────────────────────────
          _SidebarHeader(),

          // ── Zone 2 : Navigation ──────────────────────
          const SizedBox(height: 10),
          const Divider(color: AppColors.bordure),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Navigation'.toUpperCase(),
              style: GoogleFonts.jost(
                fontSize: 10,
                color: AppColors.textDiscret,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _NavItem(
                    icon: Icons.dashboard_outlined,
                    label: 'Tableau de bord',
                    index: 0,
                    selected: selectedIndex == 0,
                    onTap: () => onDestinationSelected(0),
                  ),
                  _NavItem(
                    icon: Icons.apartment_outlined,
                    label: 'Propriétés',
                    index: 1,
                    selected: selectedIndex == 1,
                    onTap: () => onDestinationSelected(1),
                  ),
                  _NavItem(
                    icon: Icons.calendar_month_outlined,
                    label: 'Réservations',
                    index: 2,
                    selected: selectedIndex == 2,
                    onTap: () => onDestinationSelected(2),
                  ),
                ],
              ),
            ),
          ),

          // ── Zone 3 : Footer (Isolé pour la performance) ─
          const _SidebarFooter(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// COMPOSANTS ISOLÉS
// ---------------------------------------------------------

class _SidebarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'Espace Admin'.toUpperCase(),
            style: const TextStyle(
              color: AppColors.orAttenu,
              fontSize: 9,
              wordSpacing: -0.2,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Text('AURA', style: GoogleFonts.cormorantGaramond(fontSize: 18)),
              const Text(
                ' · ',
                style: TextStyle(color: AppColors.or, fontSize: 18),
              ),
              Text(
                'ESTATES',
                style: GoogleFonts.cormorantGaramond(fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SidebarFooter extends ConsumerWidget {
  const _SidebarFooter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Column(
      children: [
        const Divider(color: AppColors.bordure),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              const Icon(Icons.circle, color: AppColors.succes, size: 9),
              const SizedBox(width: 5),
              Text(
                'Connecté',
                style: GoogleFonts.jost(
                  color: AppColors.textDiscret,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  ref.read(authControllerProvider.notifier).logout();
                },
                child: const Icon(
                  Icons.logout,
                  size: 16,
                  color: AppColors.orAttenu,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: AppColors.orAttenu.withAlpha(50),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.or, width: 0.8),
                ),
                child: const Center(
                  child: Icon(Icons.person, color: AppColors.or),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gestion de l'état asynchrone à la manière Riverpod
                  authState.when(
                    data: (user) {
                      if (user == null) {
                        return Text(
                          'Non connecté',
                          style: GoogleFonts.jost(
                            color: AppColors.textDiscret,
                            fontSize: 10,
                          ),
                        );
                      }
                      return Text(
                        user.email ?? 'Email non renseigné',
                        style: GoogleFonts.jost(
                          color: AppColors.textSecondaire,
                          letterSpacing: -0.1,
                          fontSize: 9,
                        ),
                      );
                    },
                    loading: () => const SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(
                        color: AppColors.or,
                        strokeWidth: 2,
                      ),
                    ),
                    error: (_, __) => Text(
                      'Erreur',
                      style: GoogleFonts.jost(
                        color: AppColors.erreur,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Text(
                    'Administrateur',
                    style: GoogleFonts.jost(
                      color: AppColors.textDiscret,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.surfaceElevee : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? AppColors.or : AppColors.textSecondaire,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: selected ? AppColors.or : AppColors.textSecondaire,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

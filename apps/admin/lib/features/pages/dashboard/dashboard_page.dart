import 'package:admin/features/pages/bookings/bookings_page.dart';
import 'package:admin/features/pages/components/admin_sidebar.dart';
import 'package:admin/features/pages/properties/properties_page.dart';
import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────
//  Shell principal (sidebar + page courante)
// ─────────────────────────────────────────────────────────
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = const [
    _DashboardBody(),
    PropertiesPage(),
    BookingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.noir,
      body: Row(
        children: [
          AdminSidebar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => setState(() => _selectedIndex = i),
          ),
          const VerticalDivider(width: 0.5, color: AppColors.surfaceElevee),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Corps du tableau de bord
// ─────────────────────────────────────────────────────────
class _DashboardBody extends ConsumerWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProperties = ref.watch(propertiesStreamProvider);
    final asyncBookings = ref.watch(bookingsStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ────────────────────────────────────────
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Tableau de bord',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textPrimaire,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateTime.now().toLocal().toString().split(' ')[0],
                style: GoogleFonts.jost(
                  fontSize: 13,
                  color: AppColors.textSecondaire,
                ),
              ),
            ],
          ),
        ),
        const Divider(color: AppColors.bordure, height: 0.5, thickness: 0.5),

        // ── Body scrollable ────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Cartes de stats ──────────────────────
                _buildStatCards(asyncProperties, asyncBookings),
                const SizedBox(height: 28),

                // ── Dernières demandes ───────────────────
                Text(
                  'Dernières demandes',
                  style: GoogleFonts.jost(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimaire,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '5 réservations les plus récentes',
                  style: GoogleFonts.jost(
                    fontSize: 11,
                    color: AppColors.textDiscret,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRecentBookings(asyncBookings),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── 4 cartes de statistiques ────────────────────────────
  Widget _buildStatCards(
    AsyncValue<List<PropertyModel>> asyncProperties,
    AsyncValue<List<BookingModel>> asyncBookings,
  ) {
    // Calcule les stats depuis les streams
    final propCount = asyncProperties.asData?.value.length;
    final bookings = asyncBookings.asData?.value;
    final totalBookings = bookings?.length;
    final enAttente = bookings?.where((b) => b.status == 'En attente').length;
    final confirmees = bookings?.where((b) => b.status == 'Confirmée').length;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.villa_outlined,
            label: 'Propriétés',
            value: propCount,
            color: AppColors.or,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.calendar_month_outlined,
            label: 'Réservations',
            value: totalBookings,
            color: AppColors.or,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.hourglass_empty_rounded,
            label: 'En attente',
            value: enAttente,
            color: AppColors.or,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_outline_rounded,
            label: 'Confirmées',
            value: confirmees,
            color: AppColors.succes,
          ),
        ),
      ],
    );
  }

  // ── Mini-tableau des 5 dernières demandes ───────────────
  Widget _buildRecentBookings(AsyncValue<List<BookingModel>> asyncBookings) {
    return asyncBookings.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(color: AppColors.or, strokeWidth: 2),
        ),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Erreur : $e',
          style: GoogleFonts.jost(fontSize: 12, color: AppColors.erreur),
        ),
      ),
      data: (bookings) {
        final recent = bookings.take(5).toList();
        if (recent.isEmpty) {
          return _EmptyState(
            icon: Icons.inbox_outlined,
            label: 'Aucune réservation pour le moment',
          );
        }
        return _RecentBookingsTable(bookings: recent);
      },
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Carte de statistique
// ─────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? value; // null = loading
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevee,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.bordure, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withAlpha(18),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: color.withAlpha(50), width: 0.5),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 14),

          // Valeur
          value == null
              ? Container(
                  width: 40,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.bordure,
                    borderRadius: BorderRadius.circular(4),
                  ),
                )
              : Text(
                  value.toString(),
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaire,
                  ),
                ),
          const SizedBox(height: 4),

          // Label
          Text(
            label,
            style: GoogleFonts.jost(
              fontSize: 11.5,
              color: AppColors.textDiscret,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Mini-tableau des dernières réservations (lecture seule)
// ─────────────────────────────────────────────────────────
class _RecentBookingsTable extends StatelessWidget {
  final List<BookingModel> bookings;
  const _RecentBookingsTable({required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevee,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.bordure, width: 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const Divider(color: AppColors.bordure, height: 0.5, thickness: 0.5),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bookings.length,
            separatorBuilder: (_, __) => const Divider(
              color: AppColors.bordure,
              height: 0.5,
              thickness: 0.5,
            ),
            itemBuilder: (_, i) => _buildRow(bookings[i]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    const cols = ['Client', 'Propriété', 'Date souhaitée', 'Statut'];
    const flexes = [3, 3, 2, 2];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: List.generate(
          cols.length,
          (i) => Expanded(
            flex: flexes[i],
            child: Text(
              cols[i],
              style: GoogleFonts.jost(
                fontSize: 11,
                color: AppColors.textDiscret,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(BookingModel b) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Client
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  b.userName,
                  style: GoogleFonts.jost(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaire,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  b.userMail,
                  style: GoogleFonts.jost(
                    fontSize: 10.5,
                    color: AppColors.textDiscret,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Propriété
          Expanded(
            flex: 3,
            child: Text(
              b.currentProperty.title,
              style: GoogleFonts.jost(
                fontSize: 12,
                color: AppColors.textSecondaire,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Date
          Expanded(
            flex: 2,
            child: Text(
              b.bookingDate.split(' ')[0],
              style: GoogleFonts.jost(
                fontSize: 12,
                color: AppColors.textSecondaire,
              ),
            ),
          ),

          // Statut
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _StatusBadge(status: b.status),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      'En attente' => (AppColors.or.withAlpha(30), AppColors.or),
      'Confirmée' => (AppColors.succes.withAlpha(30), AppColors.succes),
      'Annulée' => (AppColors.erreur.withAlpha(30), AppColors.erreur),
      _ => (AppColors.textDiscret.withAlpha(30), AppColors.textDiscret),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: GoogleFonts.jost(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: fg,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String label;
  const _EmptyState({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevee,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.bordure, width: 0.5),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(icon, color: AppColors.textDiscret, size: 28),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.jost(
                fontSize: 13,
                color: AppColors.textDiscret,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

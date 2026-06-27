import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────
//  Constantes statut
// ─────────────────────────────────────────────────────────
const String kEnAttente = 'En attente';
const String kConfirmee = 'Confirmée';
const String kAnnulee = 'Annulée';

// ─────────────────────────────────────────────────────────
//  Widget principal
// ─────────────────────────────────────────────────────────
class BookingRequestsTable extends ConsumerWidget {
  final List<BookingModel> bookings;

  const BookingRequestsTable({super.key, required this.bookings});

  // ── Changement de statut avec popup de confirmation ────
  Future<void> _confirmChange(
    BuildContext context,
    WidgetRef ref,
    BookingModel booking,
    String newStatus,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withAlpha(160),
      builder: (_) =>
          _StatusChangeDialog(booking: booking, newStatus: newStatus),
    );
    if (confirmed != true) return;

    await ref
        .read(bookingControllerProvider.notifier)
        .updateBookingStatus(id: booking.id, status: newStatus);

    // ← CORRIGÉ : context.mounted vérifié AVANT tout appel à ref ou context
    if (!context.mounted) return;
    final state = ref.read(bookingControllerProvider);
    state.hasError
        ? _showSnack(context, 'Erreur : ${state.error}', isError: true)
        : _showSnack(context, _successMessage(newStatus, booking.userName));
  }

  // ── Suppression avec popup de confirmation ─────────────
  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    BookingModel booking,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withAlpha(160),
      builder: (_) => _DeleteBookingDialog(booking: booking),
    );
    if (confirmed != true) return;

    await ref
        .read(bookingControllerProvider.notifier)
        .deleteBooking(booking.id);

    // ← CORRIGÉ : context.mounted vérifié AVANT tout appel à ref ou context
    if (!context.mounted) return;
    final state = ref.read(bookingControllerProvider);
    state.hasError
        ? _showSnack(context, 'Erreur : ${state.error}', isError: true)
        : _showSnack(context, 'Réservation de ${booking.userName} supprimée.');
  }

  String _successMessage(String status, String name) => switch (status) {
    kConfirmee => 'Réservation de $name confirmée.',
    kAnnulee => 'Réservation de $name annulée.',
    kEnAttente => 'Réservation de $name remise en attente.',
    _ => 'Statut mis à jour.',
  };

  void _showSnack(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.jost(fontSize: 13)),
        backgroundColor: isError ? AppColors.erreur : AppColors.succes,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  Build
  // ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          bookings.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookings.length,
                  separatorBuilder: (_, __) => const Divider(
                    color: AppColors.bordure,
                    height: 0.5,
                    thickness: 0.5,
                  ),
                  itemBuilder: (_, i) => _buildRow(context, ref, bookings[i]),
                ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────
  Widget _buildHeader() {
    const cols = [
      'Client',
      'Téléphone',
      'Propriété',
      'Date souhaitée',
      'Statut',
      'Actions',
    ];
    const flexes = [3, 2, 3, 2, 2, 4];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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

  // ── Ligne ──────────────────────────────────────────────
  Widget _buildRow(BuildContext context, WidgetRef ref, BookingModel b) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                    fontSize: 11,
                    color: AppColors.textDiscret,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Téléphone
          Expanded(
            flex: 2,
            child: Text(
              b.userPhone.isNotEmpty ? b.userPhone : '—',
              style: GoogleFonts.jost(
                fontSize: 12,
                color: AppColors.textSecondaire,
              ),
              overflow: TextOverflow.ellipsis,
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

          // Actions
          Expanded(
            flex: 4,
            child: _ActionButtons(
              status: b.status,
              onConfirm: () => _confirmChange(context, ref, b, kConfirmee),
              onCancel: () => _confirmChange(context, ref, b, kAnnulee),
              onRevert: () => _confirmChange(context, ref, b, kEnAttente),
              onDelete: () => _delete(context, ref, b),
            ),
          ),
        ],
      ),
    );
  }

  // ── État vide ──────────────────────────────────────────
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.inbox_outlined,
              color: AppColors.textDiscret,
              size: 28,
            ),
            const SizedBox(height: 10),
            Text(
              'Aucune réservation pour le moment',
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

// ─────────────────────────────────────────────────────────
//  Badge de statut
// ─────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      kEnAttente => (AppColors.or.withAlpha(30), AppColors.or),
      kConfirmee => (AppColors.succes.withAlpha(30), AppColors.succes),
      kAnnulee => (AppColors.erreur.withAlpha(30), AppColors.erreur),
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

// ─────────────────────────────────────────────────────────
//  Boutons d'action
//
//  En attente → [✓ Confirmer]  [✕]
//  Confirmée  → [↩ En attente] [🗑]
//  Annulée    → [↩ En attente] [🗑]
// ─────────────────────────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  final String status;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final VoidCallback onRevert;
  final VoidCallback onDelete;

  const _ActionButtons({
    required this.status,
    required this.onConfirm,
    required this.onCancel,
    required this.onRevert,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: switch (status) {
        kEnAttente => [
          _Btn(
            icon: Icons.check_rounded,
            label: 'Confirmer',
            color: AppColors.succes,
            onTap: onConfirm,
          ),
          const SizedBox(width: 5),
          _Btn(
            icon: Icons.close_rounded,
            color: AppColors.erreur,
            onTap: onCancel,
          ),
        ],
        _ => [
          _Btn(
            icon: Icons.history_rounded,
            label: 'En attente',
            color: AppColors.or,
            onTap: onRevert,
          ),
          const SizedBox(width: 5),
          _Btn(
            icon: Icons.delete_outline_rounded,
            color: AppColors.erreur,
            onTap: onDelete,
          ),
        ],
      },
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Color color;
  final VoidCallback onTap;

  const _Btn({
    required this.icon,
    required this.color,
    required this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: label != null ? 9 : 7,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: color.withAlpha(12),
          border: Border.all(color: color.withAlpha(70), width: 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            if (label != null) ...[
              const SizedBox(width: 4),
              Text(
                label!,
                style: GoogleFonts.jost(fontSize: 11.5, color: color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Dialog générique de changement de statut
//  Utilisé pour : Confirmer, Annuler, Remettre en attente
// ─────────────────────────────────────────────────────────
class _StatusChangeDialog extends StatelessWidget {
  final BookingModel booking;
  final String newStatus;

  const _StatusChangeDialog({required this.booking, required this.newStatus});

  // Config visuelle selon la cible
  _DialogConfig get _config => switch (newStatus) {
    kConfirmee => _DialogConfig(
      icon: Icons.check_circle_outline_rounded,
      iconColor: AppColors.succes,
      title: 'Confirmer la réservation',
      subtitle: 'La demande sera marquée comme confirmée.',
      btnLabel: 'Confirmer',
      btnColor: AppColors.succes,
    ),
    kAnnulee => _DialogConfig(
      icon: Icons.cancel_outlined,
      iconColor: AppColors.erreur,
      title: 'Annuler la réservation',
      subtitle: 'La demande sera marquée comme annulée.',
      btnLabel: 'Annuler la demande',
      btnColor: AppColors.erreur,
    ),
    _ => _DialogConfig(
      // kEnAttente
      icon: Icons.history_rounded,
      iconColor: AppColors.or,
      title: 'Remettre en attente',
      subtitle: 'La demande reviendra au statut « En attente ».',
      btnLabel: 'Remettre en attente',
      btnColor: AppColors.or,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final cfg = _config;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevee,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.bordure, width: 0.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: cfg.iconColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: cfg.iconColor.withAlpha(50),
                        width: 0.5,
                      ),
                    ),
                    child: Icon(cfg.icon, color: cfg.iconColor, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cfg.title,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textPrimaire,
                        ),
                      ),
                      Text(
                        cfg.subtitle,
                        style: GoogleFonts.jost(
                          fontSize: 11,
                          color: AppColors.textDiscret,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: AppColors.bordure,
              height: 0.5,
              thickness: 0.5,
            ),

            // ── Fiche client ─────────────────────────────
            Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.noir,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.bordure, width: 0.5),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevee,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.bordure,
                          width: 0.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.orAttenu,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.userName,
                            style: GoogleFonts.jost(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaire,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${booking.currentProperty.title} · ${booking.bookingDate.split(' ')[0]}',
                            style: GoogleFonts.jost(
                              fontSize: 11.5,
                              color: AppColors.textDiscret,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Badge statut actuel → flèche → nouveau statut
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _StatusBadge(status: booking.status),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 12,
                            color: AppColors.textDiscret,
                          ),
                        ),
                        _StatusBadge(status: newStatus),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Divider(
              color: AppColors.bordure,
              height: 0.5,
              thickness: 0.5,
            ),

            // ── Footer ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 13, 18, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.bordure,
                        width: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                    ),
                    child: Text(
                      'Annuler',
                      style: GoogleFonts.jost(
                        fontSize: 12,
                        color: AppColors.textSecondaire,
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: Icon(cfg.icon, size: 14),
                    label: Text(
                      cfg.btnLabel,
                      style: GoogleFonts.jost(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cfg.btnColor,
                      foregroundColor: cfg.btnColor == AppColors.or
                          ? AppColors.noir
                          : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Config interne du dialog — pas de widget, juste des données
class _DialogConfig {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String btnLabel;
  final Color btnColor;

  const _DialogConfig({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.btnLabel,
    required this.btnColor,
  });
}

// ─────────────────────────────────────────────────────────
//  Dialog confirmation suppression
// ─────────────────────────────────────────────────────────
class _DeleteBookingDialog extends StatelessWidget {
  final BookingModel booking;
  const _DeleteBookingDialog({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevee,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.bordure, width: 0.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.erreur.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.erreur.withAlpha(50),
                        width: 0.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.erreur,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Supprimer la réservation',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textPrimaire,
                        ),
                      ),
                      Text(
                        'Cette action est irréversible',
                        style: GoogleFonts.jost(
                          fontSize: 11,
                          color: AppColors.erreur.withAlpha(200),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: AppColors.bordure,
              height: 0.5,
              thickness: 0.5,
            ),

            // Corps — fiche client
            Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.noir,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.bordure, width: 0.5),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevee,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.bordure,
                          width: 0.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.orAttenu,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.userName,
                            style: GoogleFonts.jost(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaire,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${booking.currentProperty.title} · ${booking.bookingDate.split(' ')[0]}',
                            style: GoogleFonts.jost(
                              fontSize: 11.5,
                              color: AppColors.textDiscret,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _StatusBadge(status: booking.status),
                  ],
                ),
              ),
            ),

            const Divider(
              color: AppColors.bordure,
              height: 0.5,
              thickness: 0.5,
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 13, 18, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.bordure,
                        width: 0.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                    ),
                    child: Text(
                      'Annuler',
                      style: GoogleFonts.jost(
                        fontSize: 12,
                        color: AppColors.textSecondaire,
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: const Icon(Icons.delete_outline_rounded, size: 14),
                    label: Text(
                      'Supprimer',
                      style: GoogleFonts.jost(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.erreur,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
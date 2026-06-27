import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showDeletePropertyDialog({
  required BuildContext context,
  required WidgetRef ref,
  required PropertyModel property,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withAlpha(160),
    builder: (_) => _DeletePropertyDialog(ref: ref, property: property),
  );
}

// ─────────────────────────────────────────────────────────
//  Dialog widget
// ─────────────────────────────────────────────────────────
class _DeletePropertyDialog extends StatefulWidget {
  final WidgetRef ref;
  final PropertyModel property;

  const _DeletePropertyDialog({required this.ref, required this.property});

  @override
  State<_DeletePropertyDialog> createState() => _DeletePropertyDialogState();
}

class _DeletePropertyDialogState extends State<_DeletePropertyDialog> {
  bool _isLoading = false;

  Future<void> _confirm() async {
    setState(() => _isLoading = true);

    await widget.ref
        .read(propertyControllerProvider.notifier)
        .deleteProperty(widget.property.id);

    final state = widget.ref.read(propertyControllerProvider);

    if (!mounted) return;

    if (state.hasError) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur : ${state.error}',
            style: GoogleFonts.jost(fontSize: 13),
          ),
          backgroundColor: AppColors.erreur,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '« ${widget.property.title} » supprimée.',
          style: GoogleFonts.jost(fontSize: 13),
        ),
        backgroundColor: AppColors.succes,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 420,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevee,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.bordure, width: 0.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const Divider(
              color: AppColors.bordure,
              height: 0.5,
              thickness: 0.5,
            ),
            _buildBody(),
            const Divider(
              color: AppColors.bordure,
              height: 0.5,
              thickness: 0.5,
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Row(
        children: [
          // Icône d'avertissement
          Container(
            width: 36,
            height: 36,
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
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Supprimer la propriété',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 18,
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
    );
  }

  // ── Corps — fiche récap de la propriété ───────────────
  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vous êtes sur le point de supprimer :',
            style: GoogleFonts.jost(
              fontSize: 12.5,
              color: AppColors.textSecondaire,
            ),
          ),
          const SizedBox(height: 12),

          // Fiche propriété
          Container(
            decoration: BoxDecoration(
              color: AppColors.noir,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: AppColors.bordure, width: 0.5),
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Miniature image
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: widget.property.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.property.imageUrl,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _ImageFallback(),
                        )
                      : _ImageFallback(),
                ),
                const SizedBox(width: 14),

                // Infos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.property.title,
                        style: GoogleFonts.jost(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaire,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.property.location,
                        style: GoogleFonts.jost(
                          fontSize: 11.5,
                          color: AppColors.textDiscret,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.sell_outlined,
                            label:
                                '${priceFormat(widget.property.price)} ${widget.property.currency}',
                          ),
                          const SizedBox(width: 6),
                          _InfoChip(
                            icon: Icons.square_foot_outlined,
                            label: '${widget.property.area.toInt()} m²',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Footer — boutons ───────────────────────────────────
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Annuler
          OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.bordure, width: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            child: Text(
              'Annuler',
              style: GoogleFonts.jost(
                fontSize: 12.5,
                color: AppColors.textSecondaire,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Confirmer suppression
          ElevatedButton(
            onPressed: _isLoading ? null : _confirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.erreur,
              disabledBackgroundColor: AppColors.erreur.withAlpha(80),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.delete_outline_rounded, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Supprimer',
                        style: GoogleFonts.jost(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Micro-widgets
// ─────────────────────────────────────────────────────────

class _ImageFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      color: AppColors.surfaceElevee,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.orAttenu,
        size: 22,
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevee,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.bordure, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.textDiscret),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.jost(fontSize: 11, color: AppColors.textDiscret),
          ),
        ],
      ),
    );
  }
}

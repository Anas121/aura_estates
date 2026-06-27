import 'package:admin/features/pages/properties/delete_property_dialog.dart';
import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PropertiesTable extends ConsumerWidget {
  final List<PropertyModel> properties;

  const PropertiesTable({super.key, required this.properties});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevee,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),
          Divider(color: AppColors.bordure),
          // Rows
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: properties.length,
            separatorBuilder: (_, __) => Divider(color: AppColors.bordure),
            itemBuilder: (context, index) =>
                _buildRow(context, ref, properties[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              'Image',
              style: GoogleFonts.jost(color: AppColors.textSecondaire),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Propriété',
              style: GoogleFonts.jost(color: AppColors.textSecondaire),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 50),

              child: Text(
                'Prix',
                style: GoogleFonts.jost(color: AppColors.textSecondaire),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Statut',
              style: GoogleFonts.jost(color: AppColors.textSecondaire),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Modifier',
              style: GoogleFonts.jost(color: AppColors.textSecondaire),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Supprimer',
              style: GoogleFonts.jost(color: AppColors.textSecondaire),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, ref, PropertyModel currentProperty) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                currentProperty.imageUrl,
                width: 100,
                height: 60,
                fit: BoxFit.cover,
                // Pendant le chargement
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: AppColors.surfaceElevee,
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.or),
                    ),
                  );
                },
                // Si l'URL est cassée ou vide
                errorBuilder: (context, error, stack) => Container(
                  color: AppColors.surfaceElevee,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.orAttenu,
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentProperty.title,
                  style: GoogleFonts.jost(color: AppColors.textPrimaire),
                ),
                Text(
                  currentProperty.category,
                  style: TextStyle(color: AppColors.textDiscret, fontSize: 11),
                ),
                Text(
                  currentProperty.location,
                  style: TextStyle(color: AppColors.textDiscret, fontSize: 11),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Text(
                '${priceFormat(currentProperty.price)} ${currentProperty.currency}',
                style: GoogleFonts.jost(
                  color: AppColors.or,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: _buildBadge(
              currentProperty.isFeatured ? 'Disponible' : 'Occupée',
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 80),
              child: OutlinedButton(
                onPressed: () =>
                    context.pushNamed('edit_property', extra: currentProperty),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                  side: BorderSide(color: AppColors.orPale),
                ),
                child: Text(
                  'Modifier',
                  style: TextStyle(color: AppColors.orPale),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 70),
              child: OutlinedButton(
                onPressed: () => showDeletePropertyDialog(
                  context: context,
                  ref: ref,
                  property: currentProperty,
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.erreur.withAlpha(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                  side: BorderSide(color: AppColors.erreur),
                ),
                child: Text(
                  'Supprimer',
                  style: TextStyle(color: AppColors.erreur),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String statut) {
    final config =
        {
          'Sous compromis': (AppColors.or.withAlpha(30), AppColors.or),
          'Disponible': (AppColors.succes.withAlpha(30), AppColors.succes),
          'Occupée': (AppColors.erreur.withAlpha(30), AppColors.erreur),
        }[statut] ??
        (AppColors.textDiscret.withAlpha(30), AppColors.textDiscret);

    return Padding(
      padding: const EdgeInsets.only(right: 70),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: config.$1,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            statut,
            style: TextStyle(
              color: config.$2,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

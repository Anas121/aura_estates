import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:aura_estates/features/properties/data/controllers/user_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritePropertyCard extends ConsumerWidget {
  final PropertyModel property;
  const FavoritePropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Slidable(
        key: ValueKey(property.id),
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                ref
                    .read(userDataControllerProvider.notifier)
                    .toggleFavorite(property.id);
              },
              borderRadius: BorderRadius.circular(15),
              autoClose: true,
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () => context.pushNamed(
            'property_details',
            pathParameters: {'id': property.id},
            extra: property,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.surfaceElevee,
            ),
            height: 80,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    property.imageUrl,
                    width: 110,
                    fit: BoxFit.cover,
                    // Pendant le chargement
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 200,
                        color: AppColors.surfaceElevee,
                        child: const Center(
                          child: CircularProgressIndicator(color: AppColors.or),
                        ),
                      );
                    },
                    // Si l'URL est cassée ou vide
                    errorBuilder: (context, error, stack) => Container(
                      height: 200,
                      color: AppColors.surfaceElevee,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.orAttenu,
                        size: 36,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.location.toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textDiscret,
                          fontSize: 9,
                          wordSpacing: 0.7,
                        ),
                      ),
                      Text(
                        property.title,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${priceFormat(property.price.toInt())} ${property.currency}',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          wordSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

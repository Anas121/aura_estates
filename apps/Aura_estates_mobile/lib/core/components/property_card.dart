import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PropertyCard extends StatelessWidget {
  final PropertyModel currentProperty;

  const PropertyCard({super.key, required this.currentProperty});

  @override
  Widget build(BuildContext context) {
    final String id = currentProperty.id;
    // final String description = currentProperty.description;
    /// Pas besoin de desc pour cette page
    final String title = currentProperty.title;
    final double price = currentProperty.price;
    final String currency = currentProperty.currency;
    final String location = currentProperty.location;
    final String category = currentProperty.category;
    final String imageUrl = currentProperty.imageUrl;
    final int bedrooms = currentProperty.bedrooms;
    final int bathrooms = currentProperty.bathrooms;
    final double area = currentProperty.area;
    final bool isFeatured = currentProperty.isFeatured;
    String availability(bool isFeatured) {
      return (isFeatured) ? 'Libre' : 'Occupé';
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => context.pushNamed(
          'property_details',
          pathParameters: {'id': id},
          extra: currentProperty,
        ),
        child: SizedBox(
          height: 320,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
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
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.overlayMoyen,
                    border: Border.all(color: AppColors.or),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: Row(
                      children: [
                        Text(category, style: TextStyle(fontSize: 10)),
                        Text(
                          ' · ${availability(isFeatured)}',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 140,
                right: 0,
                left: 0,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevee,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location.toUpperCase(),
                          style: TextStyle(
                            color: AppColors.textDiscret,
                            fontSize: 10,
                            wordSpacing: 0.7,
                          ),
                        ),
                        Text(
                          title,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              '$bedrooms Ch.',
                              style: TextStyle(
                                color: AppColors.textDiscret,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '$bathrooms Sdb',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textDiscret,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${area.toInt()} m²',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textDiscret,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Divider(
                          color: AppColors.bordure,
                          indent: 16,
                          endIndent: 16,
                        ),
                        Text(
                          'À partir de ',
                          style: TextStyle(
                            color: AppColors.textDiscret,
                            fontSize: 12,
                            wordSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${priceFormat(price.toInt())} $currency',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            wordSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

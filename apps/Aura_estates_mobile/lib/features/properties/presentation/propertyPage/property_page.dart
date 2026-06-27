import 'package:aura_estates/core/components/favorite_button.dart';
import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PropertyPage extends StatelessWidget {
  final PropertyModel property;
  final String id;
  const PropertyPage({super.key, required this.property, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    property.imageUrl,
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
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.overlayMoyen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          Icons.arrow_back,
                          size: 19,
                          color: AppColors.or,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.overlayMoyen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PRIX',
                            style: TextStyle(
                              color: AppColors.or,
                              fontSize: 10,
                              letterSpacing: 0.2,
                            ),
                          ),
                          Text(
                            '${priceFormat(property.price.toInt())} ${property.currency}',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // catégories : Villa, ...
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.overlayMoyen,
                          border: Border.all(color: AppColors.or),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          child: Text(
                            property.category.toUpperCase(),
                            style: TextStyle(color: AppColors.or, fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    property.title,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    property.location.toUpperCase(),
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: AppColors.textSecondaire,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevee,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.textDiscret,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                property.bedrooms.toString(),
                                style: GoogleFonts.cormorantGaramond(
                                  color: AppColors.blanc,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'CHAMBRES',
                                style: TextStyle(
                                  color: AppColors.textDiscret,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevee,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.textDiscret,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                property.bathrooms.toString(),
                                style: GoogleFonts.cormorantGaramond(
                                  color: AppColors.blanc,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'SALLES DE',
                                style: TextStyle(
                                  color: AppColors.textDiscret,
                                  fontSize: 8,
                                ),
                              ),
                              Text(
                                'BAIN',
                                style: TextStyle(
                                  color: AppColors.textDiscret,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevee,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.textDiscret,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                property.area.toInt().toString(),
                                style: GoogleFonts.cormorantGaramond(
                                  color: AppColors.blanc,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'm²',
                                style: TextStyle(
                                  color: AppColors.textDiscret,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(color: AppColors.surfaceElevee),
                  const SizedBox(height: 10),
                  Text(
                    'Description'.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.orAttenu,
                      wordSpacing: 0.2,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    property.description,
                    style: const TextStyle(
                      color: AppColors.textSecondaire,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      height: 1.6, // interligne confortable
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        height: 60,
        padding: EdgeInsets.all(10),
        color: AppColors.noir,
        // surfaceTintColor: AppColors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FavoriteButton(id: id),
            ElevatedButton(
              onPressed: () => context.pushNamed(
                'demande_visite',
                pathParameters: {'id': id},
                extra: property,
              ),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(8)),
              child: Text(
                'Planifier une visite',
                style: TextStyle(fontSize: 12, color: AppColors.surface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

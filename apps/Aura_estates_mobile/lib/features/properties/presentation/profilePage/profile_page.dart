import 'package:aura_estates/features/properties/presentation/profilePage/favorite_property_card.dart';
import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:aura_estates/features/properties/data/controllers/user_data_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final favoriteIds = ref.watch(userDataControllerProvider).userFavorites;
    final asyncProperties = ref.watch(propertiesStreamProvider);
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aura Estates'.toUpperCase(),
                      style: TextStyle(
                        color: AppColors.orAttenu,
                        fontSize: 13,
                        wordSpacing: -0.2,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Profile utilisateur',
                      style: GoogleFonts.cormorantGaramond(
                        color: AppColors.textPrimaire,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.noir,
                  shape: CircleBorder(
                    side: BorderSide(color: AppColors.surfaceElevee),
                  ),
                ),
                child: Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(indent: 10, endIndent: 10),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vos favoris'.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.or,
                    wordSpacing: 0.2,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          asyncProperties.when(
            data: (properties) {
              final favorites = properties
                  .where((p) => favoriteIds.contains(p.id))
                  .toList();
              if (favorites.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.surfaceElevee,
                      border: Border.all(color: AppColors.bordure),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Aucune propriété en favoris pour le moment',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jost(
                            color: AppColors.textSecondaire,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return Column(
                spacing: 10,
                children: favorites
                    .map((p) => FavoritePropertyCard(property: p))
                    .toList(),
              );
            },
            error: (error, stack) => Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Erreur : $error',
                style: TextStyle(color: AppColors.erreur),
              ),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.or),
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

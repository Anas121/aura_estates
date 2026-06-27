import 'package:aura_estates/features/properties/presentation/homePage/category_bar.dart';
import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:aura_estates/core/components/property_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final asyncProperties = ref.watch(propertiesStreamProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.noir,
        elevation: 0,
        title: Row(
          children: [
            Text('AURA', style: GoogleFonts.cormorantGaramond(fontSize: 18)),
            Text(' · ', style: TextStyle(color: AppColors.or, fontSize: 18)),
            Text('ESTATES', style: GoogleFonts.cormorantGaramond(fontSize: 18)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => context.pushNamed('profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.transparent,
              iconColor: AppColors.or,
              elevation: 0,
              shape: CircleBorder(),
              side: BorderSide(color: AppColors.bordure, width: 0.9),
            ),
            child: Icon(Icons.person),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: asyncProperties.when(
          data: (properties) {
            final selected = ref.watch(selectedCategoryProvider);
            // Filtre selon la catégorie sélectionnée
            final filtered = selected.toUpperCase() == 'TOUS'
                ? properties
                : properties
                      .where(
                        (p) =>
                            p.category.toUpperCase() == selected.toUpperCase(),
                      )
                      .toList();
            if (filtered.isEmpty) {
              return Column(
                children: [
                  _buildHeadPage(),
                  const SizedBox(height: 100),
                  Text(
                    'Aucune propriété dans',
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondaire,
                    ),
                  ),
                  Text(
                    'cette catégorie',
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondaire,
                    ),
                  ),
                ],
              );
            }
            return ListView.builder(
              itemCount: filtered.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return _buildHeadPage();
                final property = filtered[index - 1];
                return PropertyCard(currentProperty: property);
              },
            );
          },
          error: (error, sk) {
            return Text(
              'Erreur : $error',
              style: TextStyle(color: AppColors.erreur),
            );
          },
          loading: () => Center(
            child: const CircularProgressIndicator(color: AppColors.or),
          ),
        ),
      ),
    );
  }

  Widget _buildHeadPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'SÉLECTION PRIVÉE',
          style: TextStyle(
            color: AppColors.or,
            fontSize: 13,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Propriétés',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 26,
            fontStyle: FontStyle.italic,
          ),
        ),
        Text(
          'd\'Exception',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 26,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 10),
        CategoryBar(), // Bar des bouttons catégorie
      ],
    );
  }
}

import 'package:admin/features/pages/properties/properties_table.dart';
import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PropertiesPage extends ConsumerStatefulWidget {
  const PropertiesPage({super.key});

  @override
  ConsumerState<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends ConsumerState<PropertiesPage> {
  Widget addPropertyButton() {
    return ElevatedButton(
      onPressed: () => context.pushNamed('add_property'),
      style: ElevatedButton.styleFrom(),
      child: Text(
        'Ajouter',
        style: GoogleFonts.jost(
          color: AppColors.noir2,
          fontWeight: FontWeight.w600,
          wordSpacing: -0.4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asycnProperties = ref.watch(propertiesStreamProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Propriétés',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textPrimaire,
                ),
              ),
              Text(
                DateTime.now().toLocal().toString().split(' ')[0],
                style: GoogleFonts.jost(
                  fontSize: 15,
                  color: AppColors.textSecondaire,
                ),
              ),
            ],
          ),
        ),
        const Divider(color: AppColors.bordure),

        // -----------    BODY    ---------------
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: asycnProperties.when(
                data: (data) {
                  if (data.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Aucune propriété pour l'instant!",
                          style: GoogleFonts.jost(color: AppColors.erreur),
                        ),
                        addPropertyButton(),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data.length} propriétés disponibles',
                                style: GoogleFonts.jost(
                                  color: AppColors.textPrimaire,
                                  fontSize: 14,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              Text(
                                'Synchronisé en temps réel',
                                style: GoogleFonts.jost(
                                  color: AppColors.textDiscret,
                                  fontSize: 11,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                          addPropertyButton(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      PropertiesTable(properties: data),
                    ],
                  );
                },
                error: (error, sk) => Text('Erreur!\n$error'),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.or),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

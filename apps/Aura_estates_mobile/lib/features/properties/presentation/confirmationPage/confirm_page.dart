import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmPage extends StatelessWidget {
  final String id;
  const ConfirmPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.or, width: 0.8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(21),
                child: Icon(Icons.check, color: AppColors.or, size: 27),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Demande Enregistrée',
              style: GoogleFonts.cormorantGaramond(
                color: AppColors.textPrimaire,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                wordSpacing: -0.2,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 13),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Votre concierge privé étudie votre dossier d'accès",
                    style: GoogleFonts.jost(
                      color: AppColors.textDiscret,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    "sous 24h. Un e-mail de confirmation vous a été",
                    style: GoogleFonts.jost(
                      color: AppColors.textDiscret,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    "envoyé.",
                    style: GoogleFonts.jost(
                      color: AppColors.textDiscret,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 230,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevee,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.bordure, width: 0.9),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 3),
                      Text(
                        'Référence dossier'.toUpperCase(),
                        style: GoogleFonts.jost(
                          color: AppColors.textDiscret,
                          fontSize: 9,
                          wordSpacing: 0.5,
                          letterSpacing: -0.3,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        id.toUpperCase(),
                        style: GoogleFonts.cormorantGaramond(
                          color: AppColors.orAttenu,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.goNamed('home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.noir,
                foregroundColor: AppColors.noir2,
                minimumSize: Size(230, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: AppColors.bordure),
                ),
                textStyle: GoogleFonts.jost(fontWeight: FontWeight.w700),
              ),
              child: Text(
                'Fermer le showroom'.toUpperCase(),
                style: GoogleFonts.jost(
                  color: AppColors.textSecondaire,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

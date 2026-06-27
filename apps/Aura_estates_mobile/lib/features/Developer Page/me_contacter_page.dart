import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class MeContacterPage extends StatelessWidget {
  const MeContacterPage({super.key});
  Future<void> _envoyerEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'stiti.anas@proton.me',
      // Optionnel : Tu peux pré-remplir le sujet et le corps du mail
      // query: 'subject=Prise de contact&body=Bonjour,',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // Gérer l'erreur (ex: afficher un SnackBar si aucun client mail n'est installé)
      debugPrint('Impossible d\'ouvrir le client mail pour $emailUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 3),
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
                        'Développeur'.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.orAttenu,
                          fontSize: 12,
                          wordSpacing: -0.2,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'Me contacter',
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
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '● Disponible pour de nouvelles missions',
                    style: GoogleFonts.jost(
                      color: AppColors.or,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.or,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 60,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            'assets/icons/whatsapp_icon.svg',
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Whatsapp'.toUpperCase(),
                              style: GoogleFonts.jost(
                                color: AppColors.noir,
                                fontSize: 14,

                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '+212 6 .. .. .. ..',
                              style: GoogleFonts.jost(
                                color: AppColors.noir,
                                fontSize: 12,
                                // fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 80),
                        Icon(Icons.arrow_forward_ios, color: AppColors.noir),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: _envoyerEmail,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.noir,
                        border: Border.all(color: AppColors.or),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 60,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(Icons.mail, color: AppColors.or),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'EMail'.toUpperCase(),
                                style: GoogleFonts.jost(
                                  color: AppColors.or,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              Text(
                                'stiti.anas@proton.me',
                                style: GoogleFonts.jost(
                                  color: AppColors.textSecondaire,
                                  fontSize: 12,

                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 60),
                          Icon(Icons.arrow_forward_ios, color: AppColors.or),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Réponse sous 24h en moyenne',
                      style: GoogleFonts.jost(
                        color: AppColors.textDiscret,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
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

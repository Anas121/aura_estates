import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DeveloperPage extends StatefulWidget {
  const DeveloperPage({super.key});

  @override
  State<DeveloperPage> createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.noir2,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.noir,
              borderRadius: BorderRadius.circular(15),
            ),
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.orAttenu,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Icon(
                        Icons.person_outline_outlined,
                        color: AppColors.or,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Développeur flutter freelance'.toUpperCase(),
                  style: GoogleFonts.jost(
                    color: AppColors.or,
                    wordSpacing: 1,
                    letterSpacing: 1.5,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Anas Stiti',
                  style: GoogleFonts.cormorantGaramond(
                    color: AppColors.textPrimaire,
                    wordSpacing: 1,
                    letterSpacing: 1.5,
                    fontSize: 25,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Text(
                    'Je conçois des applications vitrines avec back-office de gestion, pour indépendants et petites entreprises.',
                    style: TextStyle(
                      color: AppColors.textDiscret,
                      fontSize: 10.5,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.or),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Text(
                            'Flutter',
                            style: TextStyle(color: AppColors.or, fontSize: 10),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.or),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Text(
                            'Firebase',
                            style: TextStyle(color: AppColors.or, fontSize: 10),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.or),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Text(
                            'Riverpod',
                            style: TextStyle(color: AppColors.or, fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: ElevatedButton(
                    onPressed: () => context.pushNamed('me_contacter'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 52),
                    ),
                    child: Text(
                      'Me contacter',
                      style: TextStyle(
                        color: AppColors.noir,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                GestureDetector(
                  onTap: () => context.goNamed('home'),
                  child: Text(
                    'voir la démo ➙',
                    style: TextStyle(
                      color: AppColors.or,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
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

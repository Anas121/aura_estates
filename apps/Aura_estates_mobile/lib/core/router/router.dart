import 'package:aura_estates/features/Developer%20Page/developer_page.dart';
import 'package:aura_estates/features/Developer%20Page/me_contacter_page.dart';
import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:aura_estates/features/properties/presentation/confirmationPage/confirm_page.dart';
import 'package:aura_estates/features/properties/presentation/demandeVisite/demande_visite_page.dart';
import 'package:aura_estates/features/properties/presentation/homePage/home_page.dart';
import 'package:aura_estates/features/properties/presentation/profilePage/profile_page.dart';
import 'package:aura_estates/features/properties/presentation/propertyPage/property_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/developper_page',
  routes: [
    GoRoute(
      name: 'developper_page',
      path: '/developper_page',
      builder: (context, state) => const DeveloperPage(),
      routes: [
        GoRoute(
          name: 'me_contacter',
          path: '/me_contacter_page',
          builder: (context, state) => const MeContacterPage(),
        ),
        GoRoute(
          name: 'home',
          path: '/home',
          builder: (context, state) => const HomePage(),
          routes: [
            GoRoute(
              name: 'profile',
              path: '/profile_page',
              builder: (context, state) => ProfilePage(),
            ),
            // SOUS-ROUTE : Détails d'une propriété spécifique
            // URL finale : /home/property/ID_DE_LA_propriété
            GoRoute(
              name: 'property_details',
              path: '/property/:id',
              builder: (context, state) {
                final String propertyId = state.pathParameters['id']!;
                final PropertyModel property = state.extra as PropertyModel;
                return PropertyPage(property: property, id: propertyId);
              },
              routes: [
                GoRoute(
                  name: 'demande_visite',
                  path: '/demande_visite',
                  builder: (context, state) {
                    final String propertyId = state.pathParameters['id']!;
                    final PropertyModel property = state.extra as PropertyModel;
                    return DemandeVisitePage(
                      id: propertyId,
                      currentProperty: property,
                    );
                  },
                  routes: [
                    GoRoute(
                      name: 'confirm',
                      path: '/confirm_page',
                      builder: (context, state) {
                        final String propertyId = state.pathParameters['id']!;
                        return ConfirmPage(id: propertyId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

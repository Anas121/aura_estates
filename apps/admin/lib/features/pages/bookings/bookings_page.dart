import 'package:admin/features/pages/bookings/bookings_requests_table.dart';
import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingsPage extends ConsumerStatefulWidget {
  const BookingsPage({super.key});

  @override
  ConsumerState<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends ConsumerState<BookingsPage> {
  @override
  Widget build(BuildContext context) {
    final asyncBooking = ref.watch(bookingsStreamProvider);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Réservations',
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
              child: ListView(
                children: [
                  Text(
                    'Réservations & demandes de visite',
                    style: GoogleFonts.jost(
                      color: AppColors.textPrimaire,
                      fontSize: 14,
                      letterSpacing: -0.2,
                    ),
                  ),

                  asyncBooking.when(
                    data: (data) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data.length} demande(s) disponibles',
                            style: GoogleFonts.jost(
                              color: AppColors.textDiscret,
                              fontSize: 11,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          BookingRequestsTable(bookings: data),
                        ],
                      );
                    },
                    error: (error, sk) {
                      return Center(
                        child: Text(
                          'Erreur de chargement!\n$error',
                          style: TextStyle(
                            color: AppColors.erreur,
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                    loading: () => Center(
                      child: const CircularProgressIndicator(
                        color: AppColors.or,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DemandeVisitePage extends ConsumerStatefulWidget {
  final String id;
  final PropertyModel currentProperty;
  const DemandeVisitePage({
    super.key,
    required this.id,
    required this.currentProperty,
  });

  @override
  ConsumerState<DemandeVisitePage> createState() => _DemandeVisitePageState();
}

class _DemandeVisitePageState extends ConsumerState<DemandeVisitePage> {
  late final TextEditingController userName;
  late final TextEditingController userMail;
  late final TextEditingController userPhone;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    userName = TextEditingController();
    userMail = TextEditingController();
    userPhone = TextEditingController();
  }

  @override
  void dispose() {
    userName.dispose();
    userMail.dispose();
    userPhone.dispose();
    super.dispose();
  }

  Widget textFieldDemande(TextEditingController filedController) {
    return TextField(
      controller: filedController,
      maxLength: 50,
      style: GoogleFonts.jost(color: AppColors.textPrimaire, fontSize: 13),
      cursorColor: AppColors.textSecondaire, // Le curseur clignote
      decoration: InputDecoration(
        counterText: '',
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,

        fillColor: AppColors.noir2,
        labelStyle: const TextStyle(color: AppColors.textDiscret, fontSize: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.bordure, width: 0.6),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.or, width: 0.6),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    // Le bouclier anti-crash :
    if (!mounted) return;

    if (picked != null &&
        picked != selectedDate &&
        (DateTime.now().compareTo(picked) <= 0)) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(bookingControllerProvider);
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: AppColors.noir,
        height: 90,
        elevation: 0,
        child: Column(
          children: [
            const Divider(),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await ref
                        .read(bookingControllerProvider.notifier)
                        .addBookingRequest(
                          BookingModel(
                            currentProperty: widget.currentProperty,
                            userName: userName.text,
                            userMail: userMail.text,
                            userPhone: userPhone.text,
                            bookingDate: selectedDate.toString(),
                          ),
                        );

                    // 2. RÈGLE D'OR : On vérifie si l'utilisateur n'a pas quitté la page pendant l'attente
                    if (!mounted) return;
                    context.pushNamed(
                      'confirm',
                      pathParameters: {'id': widget.id},
                    );
                  } catch (e, stackTrace) {
                    if (!mounted) return;
                    debugPrint('🛑 ERREUR FATALE : $e');
                    debugPrint('🛑 STACKTRACE : $stackTrace');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erreur interne : $e'),
                        backgroundColor: Colors.red.shade900,
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send_sharp, color: AppColors.noir, size: 12),
                    Text(
                      ' Confirmer la demande',
                      style: TextStyle(
                        color: AppColors.noir,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
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
                        'Service Conciergerie'.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.orAttenu,
                          fontSize: 12,
                          wordSpacing: -0.2,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'Demande de Visite',
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
                    'Nom complet'.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.or,
                      wordSpacing: 0.2,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  textFieldDemande(userName),
                  const SizedBox(height: 8),
                  Text(
                    'Adresse email'.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.or,
                      wordSpacing: 0.2,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  textFieldDemande(userMail),
                  Text(
                    'Téléphone'.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.or,
                      wordSpacing: 0.2,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  textFieldDemande(userPhone),
                  const SizedBox(height: 8),
                  Text(
                    'Date souhaitée'.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.or,
                      wordSpacing: 0.2,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      height: 46,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.noir2,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: AppColors.or, width: 0.8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              '${selectedDate.toLocal()}'.split(' ')[0],
                              style: GoogleFonts.jost(
                                color: AppColors.textPrimaire,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.calendar_today_rounded,
                              color: AppColors.or,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

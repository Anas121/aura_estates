import 'dart:typed_data';
import 'package:aura_estates_core/aura_estates_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

// ─────────────────────────────────────────────────────────
//  Page principale
// ─────────────────────────────────────────────────────────
class EditPropertyPage extends ConsumerStatefulWidget {
  final PropertyModel property; // propriété existante pré-chargée

  const EditPropertyPage({super.key, required this.property});

  @override
  ConsumerState<EditPropertyPage> createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends ConsumerState<EditPropertyPage> {
  // Raccourci lisible
  PropertyModel get _prop => widget.property;

  // Controllers — pré-remplis avec les données existantes
  late final TextEditingController _title;
  late final TextEditingController _price;
  late final TextEditingController _currency;
  late final TextEditingController _location;
  late final TextEditingController _category;
  late final TextEditingController _description;
  late final TextEditingController _bedrooms;
  late final TextEditingController _bathrooms;
  late final TextEditingController _area;

  // Nouvelle image choisie (null = garder l'image existante)
  XFile? _newImage;
  Uint8List? _newImageBytes;

  late bool _isAvailable;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: _prop.title);
    _price = TextEditingController(text: _prop.price.toString());
    _currency = TextEditingController(text: _prop.currency);
    _location = TextEditingController(text: _prop.location);
    _category = TextEditingController(text: _prop.category);
    _description = TextEditingController(text: _prop.description);
    _bedrooms = TextEditingController(text: _prop.bedrooms.toString());
    _bathrooms = TextEditingController(text: _prop.bathrooms.toString());
    _area = TextEditingController(text: _prop.area.toString());
    _isAvailable = _prop.isFeatured;
  }

  @override
  void dispose() {
    _title.dispose();
    _price.dispose();
    _currency.dispose();
    _location.dispose();
    _category.dispose();
    _description.dispose();
    _bedrooms.dispose();
    _bathrooms.dispose();
    _area.dispose();
    super.dispose();
  }

  // ── Image picker (Web-compatible) ──────────────────────
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      _newImage = picked;
      _newImageBytes = bytes;
    });
  }

  // ── Soumission ─────────────────────────────────────────
  Future<void> _submit() async {
    setState(() => _isLoading = true);

    try {
      final updated = PropertyModel(
        id: _prop.id,
        title: _title.text.trim(),
        price: double.tryParse(_price.text) ?? _prop.price,
        currency: _currency.text.trim(),
        location: _location.text.trim(),
        category: _category.text.trim(),
        description: _description.text.trim(),
        imageUrl: _prop.imageUrl, // conservé si pas de nouvelle image
        bedrooms: int.tryParse(_bedrooms.text) ?? _prop.bedrooms,
        bathrooms: int.tryParse(_bathrooms.text) ?? _prop.bathrooms,
        area: double.tryParse(_area.text) ?? _prop.area,
        isFeatured: _isAvailable,
      );

      await ref
          .read(propertyControllerProvider.notifier)
          .updatePropertyWithImage(
            id: _prop.id,
            newImage: _newImage, // null = garder l'existante
            propertyData: updated.toMap(),
          );

      final state = ref.read(propertyControllerProvider);
      if (state.hasError) {
        if (context.mounted) _showError('Erreur : ${state.error}');
        return;
      }

      if (context.mounted) context.pop();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.jost(fontSize: 13)),
        backgroundColor: AppColors.erreur,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  Build
  // ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.noir,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Divider(color: AppColors.bordure, height: 0.5, thickness: 0.5),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 22, 28, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BackButton(onPressed: () => context.pop()),
                  const SizedBox(height: 20),
                  _buildFormCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Modifier une propriété',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textPrimaire,
                ),
              ),
              const SizedBox(width: 12),
              // Badge ID de la propriété
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.or.withAlpha(18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.or.withAlpha(60),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  _prop.id.isNotEmpty
                      ? '#${_prop.id.substring(0, 8).toUpperCase()}'
                      : 'ID inconnu',
                  style: GoogleFonts.jost(
                    fontSize: 11,
                    color: AppColors.or,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          Text(
            DateTime.now().toLocal().toString().split(' ')[0],
            style: GoogleFonts.jost(
              fontSize: 13,
              color: AppColors.textSecondaire,
            ),
          ),
        ],
      ),
    );
  }

  // ── Carte formulaire ───────────────────────────────────
  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevee,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.bordure, width: 0.5),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageZone(),
          const SizedBox(height: 20),

          _Row2(
            left: _Field(
              controller: _title,
              label: 'Titre',
              icon: Icons.villa_outlined,
            ),
            right: _Field(
              controller: _price,
              label: 'Prix',
              icon: Icons.sell_outlined,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 14),

          _Row2(
            left: _Field(
              controller: _currency,
              label: 'Devise',
              icon: Icons.currency_exchange_outlined,
            ),
            right: _Field(
              controller: _location,
              label: 'Localisation',
              icon: Icons.location_on_outlined,
            ),
          ),
          const SizedBox(height: 14),

          _Row2(
            left: _Field(
              controller: _category,
              label: 'Catégorie',
              icon: Icons.style_outlined,
            ),
            right: _Field(
              controller: _area,
              label: 'Surface (m²)',
              icon: Icons.square_foot_outlined,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 14),

          _Row2(
            left: _Field(
              controller: _bedrooms,
              label: 'Chambres',
              icon: Icons.bed_outlined,
              keyboardType: TextInputType.number,
            ),
            right: _Field(
              controller: _bathrooms,
              label: 'Salles de bain',
              icon: Icons.bathtub_outlined,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 14),

          // Description — pleine largeur
          _FieldLabel('Description'),
          const SizedBox(height: 5),
          TextField(
            controller: _description,
            maxLines: 3,
            style: GoogleFonts.jost(
              fontSize: 13,
              color: AppColors.textPrimaire,
            ),
            decoration: _sharedInputDeco(Icons.description_outlined),
          ),
          const SizedBox(height: 20),

          _buildAvailabilityRow(),

          const SizedBox(height: 22),
          const Divider(color: AppColors.bordure, height: 0.5, thickness: 0.5),
          const SizedBox(height: 16),

          _buildActionRow(),
        ],
      ),
    );
  }

  // ── Zone image ─────────────────────────────────────────
  //  Priorité d'affichage :
  //    1. Nouvelle image choisie  → Image.memory  (web-compatible)
  //    2. Image existante en BDD  → Image.network
  //    3. Zone vide               → invite à uploader
  Widget _buildImageZone() {
    final hasNew = _newImageBytes != null;
    final hasExisting = _prop.imageUrl.isNotEmpty;
    final hasAny = hasNew || hasExisting;

    return GestureDetector(
      onTap: _pickImage,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 170,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.noir,
          borderRadius: BorderRadius.circular(9),
        ),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: hasNew ? AppColors.or : AppColors.bordure,
            strokeWidth: hasNew ? 1.2 : 0.8,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: hasAny
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image : nouvelle (mémoire) ou existante (réseau)
                      hasNew
                          ? Image.memory(_newImageBytes!, fit: BoxFit.cover)
                          : Image.network(
                              _prop.imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (_, child, progress) {
                                if (progress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.or,
                                    value: progress.expectedTotalBytes != null
                                        ? progress.cumulativeBytesLoaded /
                                              progress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) =>
                                  _ImageErrorPlaceholder(),
                            ),

                      // Gradient sombre en bas
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withAlpha(150),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Badge en bas à gauche : source de l'image
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: _ImageSourceBadge(isNew: hasNew),
                      ),

                      // Bouton "Changer" en bas à droite
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: _ActionChip(
                          icon: Icons.swap_horiz_outlined,
                          label: 'Changer',
                        ),
                      ),
                    ],
                  )
                // Zone vide (imageUrl absente)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_file_outlined,
                        size: 30,
                        color: AppColors.orAttenu,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Aucune image — cliquer pour en ajouter une',
                        style: GoogleFonts.jost(
                          fontSize: 13,
                          color: AppColors.textPrimaire,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'JPG, PNG — max 5 Mo',
                        style: GoogleFonts.jost(
                          fontSize: 11.5,
                          color: AppColors.textDiscret,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // ── Switch disponibilité ───────────────────────────────
  Widget _buildAvailabilityRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(
              Icons.event_available_outlined,
              size: 16,
              color: AppColors.textSecondaire,
            ),
            const SizedBox(width: 10),
            Text(
              'Propriété disponible',
              style: GoogleFonts.jost(
                fontSize: 13,
                color: AppColors.textSecondaire,
              ),
            ),
          ],
        ),
        Switch(
          value: _isAvailable,
          activeColor: AppColors.or,
          activeTrackColor: AppColors.or.withAlpha(35),
          inactiveThumbColor: AppColors.textDiscret,
          inactiveTrackColor: AppColors.bordure,
          onChanged: (v) => setState(() => _isAvailable = v),
        ),
      ],
    );
  }

  // ── Boutons d'action ───────────────────────────────────
  Widget _buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: _isLoading ? null : () => context.pop(),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.bordure, width: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          ),
          child: Text(
            'Annuler',
            style: GoogleFonts.jost(
              fontSize: 12.5,
              color: AppColors.textSecondaire,
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.or,
            disabledBackgroundColor: AppColors.orAttenu,
            foregroundColor: AppColors.noir,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.noir,
                  ),
                )
              : Text(
                  'Enregistrer les modifications',
                  style: GoogleFonts.jost(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ],
    );
  }

  InputDecoration _sharedInputDeco(IconData icon) => InputDecoration(
    prefixIcon: Icon(icon, size: 16, color: AppColors.textDiscret),
    filled: true,
    fillColor: AppColors.noir,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(color: AppColors.bordure, width: 0.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(color: AppColors.bordure, width: 0.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(color: AppColors.or, width: 1),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
    isDense: true,
  );
}

// ─────────────────────────────────────────────────────────
//  Micro-widgets spécifiques à la page Edit
// ─────────────────────────────────────────────────────────

/// Badge bas-gauche indiquant si l'image vient du serveur ou vient d'être choisie
class _ImageSourceBadge extends StatelessWidget {
  final bool isNew;
  const _ImageSourceBadge({required this.isNew});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevee.withAlpha(210),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isNew ? AppColors.or.withAlpha(80) : AppColors.bordure,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isNew ? Icons.fiber_new_outlined : Icons.cloud_done_outlined,
            size: 12,
            color: isNew ? AppColors.or : AppColors.textDiscret,
          ),
          const SizedBox(width: 5),
          Text(
            isNew ? 'Nouvelle image' : 'Image actuelle',
            style: GoogleFonts.jost(
              fontSize: 11,
              color: isNew ? AppColors.or : AppColors.textDiscret,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bouton chip générique (bas-droite de la zone image)
class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevee.withAlpha(220),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.bordure, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondaire),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.jost(
              fontSize: 11,
              color: AppColors.textSecondaire,
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder si Image.network échoue
class _ImageErrorPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceElevee,
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: AppColors.orAttenu,
          size: 32,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Widgets partagés (identiques à add_property_page.dart)
//  À déplacer dans un fichier commun si tu veux éviter la duplication
// ─────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _BackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.arrow_back,
        size: 13,
        color: AppColors.textSecondaire,
      ),
      label: Text(
        'Retour',
        style: GoogleFonts.jost(fontSize: 12, color: AppColors.textSecondaire),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.bordure, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      ),
    );
  }
}

class _Row2 extends StatelessWidget {
  final Widget left;
  final Widget right;
  const _Row2({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.jost(fontSize: 12, color: AppColors.textSecondaire),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.jost(fontSize: 13, color: AppColors.textPrimaire),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 16, color: AppColors.textDiscret),
            filled: true,
            fillColor: AppColors.noir,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(
                color: AppColors.bordure,
                width: 0.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(
                color: AppColors.bordure,
                width: 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: AppColors.or, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 10,
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double radius;

  const _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.dashWidth = 5.0,
    this.dashSpace = 4.0,
    this.radius = 9.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        dashPath.addPath(metric.extractPath(d, d + dashWidth), Offset.zero);
        d += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

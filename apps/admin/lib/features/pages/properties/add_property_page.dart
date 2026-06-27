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
class AddPropertyPage extends ConsumerStatefulWidget {
  const AddPropertyPage({super.key});

  @override
  ConsumerState<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends ConsumerState<AddPropertyPage> {
  // Controllers
  late final TextEditingController _title;
  late final TextEditingController _price;
  late final TextEditingController _currency;
  late final TextEditingController _location;
  late final TextEditingController _category;
  late final TextEditingController _description;
  late final TextEditingController _bedrooms;
  late final TextEditingController _bathrooms;
  late final TextEditingController _area;

  // Image — Uint8List pour compatibilité Flutter Web
  XFile? _selectedImage;
  Uint8List? _imageBytes;
  String? _imageError;

  bool _isAvailable = true;
  bool _isLoading = false;
  Map<String, String?> _fieldErrors = {};

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _price = TextEditingController();
    _currency = TextEditingController();
    _location = TextEditingController();
    _category = TextEditingController();
    _description = TextEditingController();
    _bedrooms = TextEditingController();
    _bathrooms = TextEditingController();
    _area = TextEditingController();
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
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final bytes = await picked.readAsBytes(); // Uint8List — marche partout
    setState(() {
      _selectedImage = picked;
      _imageBytes = bytes;
      _imageError = null;
    });
  }

  // ── Validation des champs requis ──────────────────────
  bool _validateFields() {
    final errors = <String, String?>{};

    if (_title.text.trim().isEmpty) errors['title'] = 'Champ requis';

    final priceText = _price.text.trim();
    if (priceText.isEmpty) {
      errors['price'] = 'Champ requis';
    } else if (double.tryParse(priceText) == null) {
      errors['price'] = 'Nombre invalide';
    }

    if (_currency.text.trim().isEmpty) errors['currency'] = 'Champ requis';
    if (_location.text.trim().isEmpty) errors['location'] = 'Champ requis';
    if (_category.text.trim().isEmpty) errors['category'] = 'Champ requis';
    if (_description.text.trim().isEmpty)
      errors['description'] = 'Champ requis';

    setState(() => _fieldErrors = errors);
    return errors.isEmpty;
  }

  // ── Soumission ─────────────────────────────────────────
  Future<void> _submit() async {
    // Valider image + champs d'un coup — afficher toutes les erreurs ensemble
    final imageOk = _selectedImage != null;
    if (!imageOk) setState(() => _imageError = 'Veuillez ajouter une photo');
    final fieldsOk = _validateFields();
    if (!imageOk || !fieldsOk) return;

    setState(() {
      _isLoading = true;
      _imageError = null;
    });

    try {
      final property = PropertyModel(
        id: '',
        title: _title.text.trim(),
        price: double.tryParse(_price.text) ?? 0.0,
        currency: _currency.text.trim(),
        location: _location.text.trim(),
        category: _category.text.trim(),
        description: _description.text.trim(),
        imageUrl: '',
        bedrooms: int.tryParse(_bedrooms.text) ?? 0,
        bathrooms: int.tryParse(_bathrooms.text) ?? 0,
        area: double.tryParse(_area.text) ?? 0.0,
        isFeatured: _isAvailable,
      );

      await ref
          .read(propertyControllerProvider.notifier)
          .addPropertyWithImage(
            image: _selectedImage!,
            propertyData: property.toMap(),
          );

      final state = ref.read(propertyControllerProvider);
      if (state.hasError) {
        if (context.mounted) {
          _showError('Erreur : ${state.error}');
        }
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
          _Header(),
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
          // Upload image
          _buildImageUpload(),
          const SizedBox(height: 20),

          // Titre + Prix
          _Row2(
            left: _Field(
              controller: _title,
              label: 'Titre',
              icon: Icons.villa_outlined,
              errorText: _fieldErrors['title'],
            ),
            right: _Field(
              controller: _price,
              label: 'Prix',
              icon: Icons.sell_outlined,
              keyboardType: TextInputType.number,
              errorText: _fieldErrors['price'],
            ),
          ),
          const SizedBox(height: 14),

          // Prix + Devise
          _Row2(
            left: _Field(
              controller: _currency,
              label: 'Devise',
              icon: Icons.currency_exchange_outlined,
              errorText: _fieldErrors['currency'],
            ),
            right: _Field(
              controller: _location,
              label: 'Localisation',
              icon: Icons.location_on_outlined,
              errorText: _fieldErrors['location'],
            ),
          ),
          const SizedBox(height: 14),

          // Catégorie + Surface
          _Row2(
            left: _Field(
              controller: _category,
              label: 'Catégorie',
              icon: Icons.style_outlined,
              errorText: _fieldErrors['category'],
            ),
            right: _Field(
              controller: _area,
              label: 'Surface (m²)',
              icon: Icons.square_foot_outlined,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 14),

          // Chambres + SDB
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
            decoration: _inputDeco(
              Icons.description_outlined,
              errorText: _fieldErrors['description'],
            ),
          ),
          const SizedBox(height: 20),

          // Disponibilité
          _buildAvailabilityRow(),

          const SizedBox(height: 22),
          const Divider(color: AppColors.bordure, height: 0.5, thickness: 0.5),
          const SizedBox(height: 16),

          // Boutons d'action
          _buildActionRow(),
        ],
      ),
    );
  }

  // ── Zone upload image ──────────────────────────────────
  Widget _buildImageUpload() {
    final hasImage = _imageBytes != null;
    final hasError = _imageError != null;

    return GestureDetector(
      onTap: _pickImage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.noir,
              borderRadius: BorderRadius.circular(9),
            ),
            child: CustomPaint(
              painter: _DashedBorderPainter(
                color: hasError
                    ? AppColors.erreur
                    : hasImage
                    ? AppColors.or
                    : AppColors.bordure,
                strokeWidth: hasImage ? 1.2 : 0.8,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: hasImage
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.memory(_imageBytes!, fit: BoxFit.cover),
                          // Gradient + bouton modifier
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withAlpha(140),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(bottom: 12, right: 12, child: _EditChip()),
                        ],
                      )
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
                            'Glisser ou cliquer pour ajouter une photo',
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
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(
                _imageError!,
                style: GoogleFonts.jost(
                  fontSize: 11.5,
                  color: AppColors.erreur,
                ),
              ),
            ),
        ],
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
          activeThumbColor: AppColors.or,
          activeTrackColor: AppColors.or.withAlpha(35),
          inactiveThumbColor: AppColors.textDiscret,
          inactiveTrackColor: AppColors.bordure,
          onChanged: (v) => setState(() => _isAvailable = v),
        ),
      ],
    );
  }

  // ── Boutons annuler / enregistrer ─────────────────────
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
                  'Enregistrer la propriété',
                  style: GoogleFonts.jost(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ],
    );
  }

  // ── InputDecoration réutilisable ───────────────────────
  InputDecoration _inputDeco(IconData icon, {String? errorText}) {
    return InputDecoration(
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
      errorText: errorText,
      errorStyle: GoogleFonts.jost(fontSize: 11, color: AppColors.erreur),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: AppColors.erreur, width: 0.8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: AppColors.erreur, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      isDense: true,
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Sous-widgets stateless extraits pour lisibilité
// ─────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Ajouter une propriété',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: AppColors.textPrimaire,
            ),
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
}

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

class _EditChip extends StatelessWidget {
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
          const Icon(
            Icons.edit_outlined,
            size: 12,
            color: AppColors.textSecondaire,
          ),
          const SizedBox(width: 5),
          Text(
            'Modifier',
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

// ── 2 colonnes côte à côte ─────────────────────────────
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

// ── Label + TextField ──────────────────────────────────
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
  final String? errorText;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
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
              borderSide: BorderSide(
                color: hasError ? AppColors.erreur : AppColors.bordure,
                width: hasError ? 0.8 : 0.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(
                color: hasError ? AppColors.erreur : AppColors.or,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: AppColors.erreur, width: 0.8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: AppColors.erreur, width: 1),
            ),
            errorText: errorText,
            errorStyle: GoogleFonts.jost(fontSize: 11, color: AppColors.erreur),
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

// ─────────────────────────────────────────────────────────
//  Painter pour bordure en pointillés (pas de dépendance externe)
// ─────────────────────────────────────────────────────────
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
      double distance = 0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

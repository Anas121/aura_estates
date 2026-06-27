import 'package:flutter/material.dart';
import 'package:aura_estates_core/aura_estates_core.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icone;
  final TextInputType
  typeClavier; // Pour forcer le pavé numérique pour le prix/stock
  final bool isPassword;

  const MyTextfield({
    super.key,
    required this.controller,
    required this.label,
    required this.icone,
    this.typeClavier = TextInputType.text, // Texte normal par défaut
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: typeClavier,
      style: const TextStyle(
        color: AppColors.or,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      obscureText: isPassword,
      cursorColor: AppColors.textSecondaire, // Le curseur clignote
      decoration: InputDecoration(
        labelText: label,

        labelStyle: const TextStyle(
          color: AppColors.textSecondaire,
          // fontWeight: FontWeight.bold,
        ),
        // L'étiquette devient dorée et remonte quand on clique
        floatingLabelStyle: const TextStyle(
          color: AppColors.textSecondaire,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(icone, color: AppColors.textSecondaire),
        filled: true,
        fillColor: AppColors.surfaceElevee,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.or),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.textSecondaire,
            width: 1,
          ),
        ),
        // Le design à l'attaque : Bordure dorée quand le champ est sélectionné
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.or, width: 2),
        ),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      ),
    );
  }
}

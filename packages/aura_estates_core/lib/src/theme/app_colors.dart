import 'package:flutter/material.dart';

abstract class AppColors {
  // ─── Fonds ────────────────────────────────────────────────────────────────
  static const Color noir = Color(0xFF0C0C0B); // Fond principal
  static const Color noir2 = Color(0xFF141413); // Fond secondaire
  static const Color surface = Color(0xFF1E1E1C); // Cartes et tuiles
  static const Color surfaceElevee = Color(
    0xFF2A2A28,
  ); // Éléments élevés (modals, bottom sheets)
  static const Color bordure = Color(0xFF3A3A38); // Séparateurs et bordures

  // ─── Accents Or ───────────────────────────────────────────────────────────
  static const Color or = Color(0xFFC9A96E); // Or principal — CTA, accents
  static const Color orPale = Color(
    0xFFE8D5B0,
  ); // Or pâle — highlights, textes clairs
  static const Color orAttenu = Color(
    0xFF7A6340,
  ); // Or atténué — états désactivés

  // ─── Textes ───────────────────────────────────────────────────────────────
  static const Color textPrimaire = Color(
    0xFFF7F4EE,
  ); // Titres, corps principal (blanc cassé)
  static const Color textSecondaire = Color(
    0xFF9E9E98,
  ); // Descriptions, métadonnées
  static const Color textDiscret = Color(
    0xFF6B6B67,
  ); // Placeholders, labels secondaires

  // ─── Statuts ──────────────────────────────────────────────────────────────
  static const Color succes = Color(0xFF4CAF50); // Confirmation, succès
  static const Color erreur = Color(0xFFEF5350); // Erreurs, champs invalides
  static const Color avertissement = Color(
    0xFFFF9800,
  ); // Alertes, avertissements

  // ─── Utilitaires ──────────────────────────────────────────────────────────
  static const Color transparent = Colors.transparent;
  static const Color blanc = Color(0xFFF7F4EE); // Blanc cassé "old money"

  // ─── Overlays ─────────────────────────────────────────────────────────────
  static const Color overlayLeger = Color(
    0x33000000,
  ); // 20% noir — badges sur images
  static const Color overlayMoyen = Color(
    0x80000000,
  ); // 50% noir — bottom bars, navs
  static const Color overlayFort = Color(
    0xCC000000,
  ); // 80% noir — price tags, modals
}

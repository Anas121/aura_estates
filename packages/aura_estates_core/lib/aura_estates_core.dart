/// Aura Estates — Core
///
/// Couche partagée entre l'app mobile et le dashboard admin :
/// modèles, repositories (Firestore / Firebase Auth / Cloudinary),
/// controllers Riverpod, thème et utilitaires.
///
/// Les deux apps n'ont besoin que d'un seul import :
/// ```dart
/// import 'package:aura_estates_core/aura_estates_core.dart';
/// ```
library;

// ─── Models ─────────────────────────────────────────────────────────────
export 'src/models/properties_model.dart';
export 'src/models/booking_model.dart';

// ─── Repositories ───────────────────────────────────────────────────────
export 'src/repositories/property_repository.dart';
export 'src/repositories/booking_repository.dart';
export 'src/repositories/storage_repository.dart';
export 'src/repositories/image_picker_service.dart';

// ─── Controllers (Riverpod) ─────────────────────────────────────────────
export 'src/controllers/property_controller.dart';
export 'src/controllers/booking_controller.dart';

// ─── Theme ───────────────────────────────────────────────────────────────
export 'src/theme/app_colors.dart';
export 'src/theme/app_theme.dart';

// ─── Utils ───────────────────────────────────────────────────────────────
export 'src/utils/price_format.dart';

// ─── Components ──────────────────────────────────────────────────────────
export 'src/components/my_textfield.dart';

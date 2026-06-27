import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_picker_service.g.dart';

/// Service de sélection d'image multiplateforme.
///
/// Renvoie un [XFile] (et non un `File` de dart:io) : `image_picker`
/// fonctionne nativement sur mobile *et* sur le web, et `XFile.readAsBytes()`
/// est supporté partout — c'est ce qui rend ce service réutilisable tel quel
/// dans le futur dashboard admin Flutter Web.
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickGallery() async {
    return _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Optimisation B2B : compression pour forfaits data
      maxWidth: 1200, // Limite supplémentaire : évite les images 20 Mo
    );
  }

  Future<XFile?> pickFromCamera() async {
    return _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxWidth: 1200,
    );
  }
}

@riverpod
ImagePickerService imagePickerService(Ref ref) => ImagePickerService();

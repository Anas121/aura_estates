import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_picker_service.g.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickGallery() async {
    final XFile? imageBrute = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Optimisation B2B : compression pour forfaits data
      maxWidth: 1200, // Limite supplémentaire : évite les images 20 Mo
    );

    if (imageBrute == null) return null;
    return File(imageBrute.path);
  }

  Future<File?> pickFromCamera() async {
    final XFile? imageBrute = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxWidth: 1200,
    );

    if (imageBrute == null) return null;
    return File(imageBrute.path);
  }
}

@riverpod
ImagePickerService imagePickerService(Ref ref) => ImagePickerService();

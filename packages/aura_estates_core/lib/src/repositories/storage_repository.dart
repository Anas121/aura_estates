import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_repository.g.dart';

class StorageRepository {
  static const String _cloudName = 'dopdh19jk';
  static const String _uploadPreset = 'aura_estates';

  /// Envoie une image vers Cloudinary à partir de ses octets bruts (et non
  /// d'un `File` de dart:io). Ça permet à ce repository de fonctionner aussi
  /// bien sur mobile (iOS/Android) que sur Flutter Web, par ex. depuis le
  /// futur dashboard admin.
  Future<String> uploadImage({required XFile file}) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );

    final bytes = await file.readAsBytes();

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: file.name),
      );

    final response = await request.send();
    final body = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode != 200) {
      throw Exception('Cloudinary error : ${body['error']['message']}');
    }

    return body['secure_url']; // ← URL publique permanente
  }
}

@riverpod
StorageRepository storageRepository(Ref ref) => StorageRepository();

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_repository.g.dart';

class StorageRepository {
  static const String _cloudName = 'dopdh19jk';
  static const String _uploadPreset = 'aura_estates';

  Future<String> uploadImage({required File file}) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

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

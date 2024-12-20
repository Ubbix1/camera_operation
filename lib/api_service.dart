import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://test.dunite.tech';

  Future<String> fetchCommand() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/commands.json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['command'] ?? 'idle';
      } else {
        return 'idle';
      }
    } catch (e) {
      
        if (kDebugMode) {
          print('Error fetching command: $e');
        }
      
      return 'idle';
    }
  }

  Future<bool> uploadImage(String imagePath) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/controllers/upload_image.php'),
      );
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return false;
    }
  }
}

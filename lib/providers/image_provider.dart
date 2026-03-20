import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Image Provider — handles image picking and local storage
// ─────────────────────────────────────────────────────────────────────────────

class ImageNotifier extends ChangeNotifier {
  String? resultImage;

  void clearImage() {
    resultImage = null;
    notifyListeners();
  }

  void setImage(String? path) {
    resultImage = path;
    notifyListeners();
  }

  Future<void> pickImage(ImageSource source) async {
    final appDir = await getApplicationDocumentsDirectory();
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source, imageQuality: 85);

    if (image != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(image.path).copy('${appDir.path}/$fileName');
      resultImage = savedImage.path;
      notifyListeners();
    }
  }
}

final imageProvider = ChangeNotifierProvider<ImageNotifier>((ref) {
  return ImageNotifier();
});

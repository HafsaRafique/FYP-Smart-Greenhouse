// lib/services/image_picker_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from the gallery
  Future<File?> pickImageFromGallery(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85, // Compress image quality
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      _showErrorSnackBar(context, 'Error picking image from gallery: $e');
      return null;
    }
  }

  /// Take a photo using the device camera
  Future<File?> takePhotoWithCamera(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85, // Compress image quality
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      _showErrorSnackBar(context, 'Error taking photo with camera: $e');
      return null;
    }
  }

  /// Validate image for disease detection
  bool validateImageForDetection(File? imageFile, String? selectedCrop, BuildContext context) {
    if (imageFile == null) {
      _showErrorSnackBar(context, 'Please select an image');
      return false;
    }

    if (selectedCrop == null) {
      _showErrorSnackBar(context, 'Please select a crop type');
      return false;
    }

    // Check file size (max 10MB)
    int sizeInBytes = imageFile.lengthSync();
    if (sizeInBytes > 10 * 1024 * 1024) {
      _showErrorSnackBar(context, 'Image is too large. Max size is 10MB');
      return false;
    }

    // Check file extension
    String extension = imageFile.path.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
      _showErrorSnackBar(context, 'Unsupported image format');
      return false;
    }

    return true;
  }

  /// Show error snackbar
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
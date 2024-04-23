import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gellary/Model/appmodel.dart';
import 'package:gellary/View/gellary_HomeScreen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();

  void showUploadOptions(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white12.withOpacity(0.8),
        child: Container(
          height: 250,
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _openGallery(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Color(0xFFEFD8F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/gallery.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Gellary',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Segoe UI',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _openCamera(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Color(0xFFEBF6FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/camera.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Camera',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openGallery(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print('Gallery image selected: ${pickedFile.path}');
      uploadSelectedImage(context, File(pickedFile.path));
      Get.back();
    } else {
      print('No image selected.');
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      print('Camera image selected: ${pickedFile.path}');
      uploadSelectedImage(context, File(pickedFile.path));
      Get.back();
    } else {
      print('No image selected.');
    }
  }

  Future<void> uploadSelectedImage(BuildContext context, File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        var response = await _apiService.uploadImage(token, image);
        print('Upload response: $response');
        Get.snackbar('Success', 'Image uploaded successfully');
        Get.off(gellaryHome());
      } catch (e) {
        print('Error uploading image: $e');
        Get.snackbar('Error', 'Failed to upload image');
      }
    } else {
      print('No token found');
      Get.snackbar('Error', 'Authentication token not found');
    }
  }

  Future<List<String>> fetchImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        var response = await _apiService.getMyGallery(token);

        if (response['data'] != null && response['data']['images'] != null) {
          List<String> imageUrls =
              List<String>.from(response['data']['images']);
          return imageUrls;
        } else {
          print('No images found in the response');
          return [];
        }
      } catch (e) {
        print('Error fetching images: $e');
        return [];
      }
    } else {
      print('No token found');
      return [];
    }
  }
}

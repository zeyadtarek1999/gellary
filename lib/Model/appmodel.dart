import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = "https://flutter.prominaagency.com/api/";

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('Token saved: $token');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    var url = Uri.parse(baseUrl + 'auth/login');
    var response = await http.post(url, body: {
      'email': email,
      'password': password,
    });
    var decodedResponse = jsonDecode(response.body);
    print('Login response: $decodedResponse');

    if (response.statusCode == 200) {
      var token = decodedResponse['token'];
      print('token $token');
      await _saveToken(token);

      if (token != '') {
        print('done');
        Get.snackbar('Success', 'Login successful');
      } else {
        throw Exception(' not found in response');
      }
      return decodedResponse;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> uploadImage(String token, File image) async {
    var url = Uri.parse(baseUrl + 'upload');
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll({
        'Authorization': 'Bearer $token',
      })
      ..files.add(await http.MultipartFile.fromPath('img', image.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      throw Exception('Failed to upload image');
    }
  }

  Future<Map<String, dynamic>> getMyGallery(String token) async {
    var url = Uri.parse(baseUrl + 'my-gallery');
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get gallery');
    }
  }
}

import 'package:gellary/Model/appmodel.dart';
import 'package:gellary/View/gellary_HomeScreen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('the token $prefs');
    await prefs.setString('token', token);
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      var response = await _apiService.login(email.value, password.value);
      print('Login response tessst: $response');

      if (response.containsKey('token')) {
        print('Full login response: $response');

        await _saveToken(response['token']);
        Get.snackbar('Success', 'Login successful');
        Get.off(gellaryHome());
      } else {
        Get.snackbar('Error', 'Failed to login');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to login try again!');
    } finally {
      isLoading.value = false;
    }
  }
  @override
  void onInit() {
    super.onInit();
    checkTokenAndNavigate();
  }


  Future<void> checkTokenAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      Get.offAll(() => gellaryHome());
    }
  }

}

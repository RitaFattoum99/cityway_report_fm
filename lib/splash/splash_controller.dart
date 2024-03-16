import 'package:cityway_report_fm/core/native_service/secure_storage.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  late SecureStorage secureStorage;
  @override
  void onInit() async {
    secureStorage = SecureStorage();
    await checkToken();
    super.onInit();
  }

  Future<void> checkToken() async {
    String? token = await secureStorage.read("token");
    if (token != null) {
      print("token: $token");
      Get.offAllNamed('home');
    } else {
      Get.offNamed('signin');
    }
  }
}

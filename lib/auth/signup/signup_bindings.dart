import '/auth/signup/signup_controller.dart';
import 'package:get/get.dart';

class SignUpBindings extends Bindings{
  @override
  void dependencies(){
    Get.put<SignUpController>(SignUpController());
  }
}
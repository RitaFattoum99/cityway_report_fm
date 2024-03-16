import '/auth/signup/signup_service.dart';
import '/auth/user_model.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  var id = 0;
  var username = '';
  var email = '';
  var password = '';
  var confirmPassword = '';

  var registerStatus = false;
  // ignore: prefer_typing_uninitialized_variables
  var message;

  SignUpService service = SignUpService();

  Future<void> doSignUp() async {
    UserData user = UserData(
        id: id,
        username: username,
        email: email,
        password: password,
        confirmPassword: confirmPassword);
    registerStatus = await service.register(user);
    message = service.message;
  }
}

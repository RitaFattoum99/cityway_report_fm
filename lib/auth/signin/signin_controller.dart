// ignore_for_file: prefer_typing_uninitialized_variables

import '/auth/signin/signin_service.dart';
import '/auth/user_model.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  var email = '';
  var password = '';
  var loginStatus = false;
  var message;

  SignInService service = SignInService();

  Future<void> doSignIn() async {
    UserData user = UserData(email: email, password: password);
    loginStatus = await service.signIn(user);
    message = service.message;
  }
}

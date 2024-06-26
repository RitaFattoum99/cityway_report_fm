// ignore_for_file: avoid_print

import 'dart:convert';

import '/auth/user_model.dart';
import '/core/config/information.dart';
import '/core/config/service_config.dart';
import '/core/native_service/secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignInService {
  var message = '';
  var token = '';
  var role = '';
  var userID = 0;
  var url = Uri.parse(ServiceConfig.domainNameServer + ServiceConfig.signIn);
  Future<bool> signIn(UserData user) async {
    print("signIn");

    var response = await http.post(url, headers: {
      'User-Agent': 'PostmanRuntime/7.37.0',
      'Accept': 'application/json',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive'
    }, body: {
      'email': user.email,
      'password': user.password,
    });

    print(response.statusCode);
    print(response.body);
    var jsonresponse = jsonDecode(response.body);
    message = jsonresponse['message'];

    if (response.statusCode == 200 || response.statusCode == 201) {
      token = jsonresponse['data']['token'];
      role = jsonresponse['data']['roles'][0];
      userID = jsonresponse['data']['id'];
      print('user id : $userID');
      print("role: $role");
      print("token $token");

      Information.TOKEN = token;
      Information.role = role;
      Information.userId = userID;
      SecureStorage secureStorage = SecureStorage();
      await secureStorage.save("token", Information.TOKEN);
      await secureStorage.save("role", Information.role);
      await secureStorage.saveInt("id", Information.userId);
      Get.offNamed('home');

      // message = "You are logged in successfully";
      print(message);
      return true;
    } else if (response.statusCode == 422 || response.statusCode == 500) {
      // message = "please verify your information";

      print(message);
      return false;
    } else {
      // message = "there is error..";
      print(message);
      return false;
    }
  }
}

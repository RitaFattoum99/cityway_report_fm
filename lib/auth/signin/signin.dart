// ignore_for_file: avoid_print
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '/auth/signin/signin_controller.dart';
import '/core/resource/color_manager.dart';
import '/core/resource/size_manger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  SignInController signinController = Get.put(SignInController());

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppPaddingManger.p100,
            left: AppPaddingManger.p12,
            right: AppPaddingManger.p12,
            bottom: AppPaddingManger.p12,
          ),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: size.height * 0.1,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                TextFormField(
                  onChanged: (value) {
                    signinController.email = value;
                  },
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    labelStyle: const TextStyle(
                        color: AppColorManger.greyAppColor, fontSize: 12),
                    hintText: ' ادخل بريدك الإلكتروني',
                    prefixIcon: const Icon(
                      Icons.email,
                      color: AppColorManger.mainAppColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: const EdgeInsets.all(12.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرقم مطلوب';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  onChanged: (value) {
                    signinController.password = value;
                  },
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    labelStyle: const TextStyle(
                        color: AppColorManger.greyAppColor, fontSize: 12),
                    hintText: ' ادخل كلمة المرور',
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: AppColorManger.mainAppColor,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // Toggle the visibility of the confirm password
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: const EdgeInsets.all(12.0),
                  ),
                  obscureText: !isPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'كلمة المرور مطلوبة';
                    }
                    return null;
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: AppPaddingManger.p10,
                    right: AppPaddingManger.p12,
                    left: AppPaddingManger.p12,
                  ),
                ),
                const SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppPaddingManger.p20,
                    left: AppPaddingManger.p50,
                    right: AppPaddingManger.p12,
                    bottom: AppPaddingManger.p12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "تسجيل دخول",
                        style: TextStyle(
                          color: AppColorManger.secondaryAppColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          print("email: ${signinController.email}");
                          print("password: ${signinController.password}");
                          await signinController.doSignIn();
                          if (signinController.loginStatus) {
                            EasyLoading.showSuccess(signinController.message,
                                duration: const Duration(seconds: 2));
                            Get.offNamed('home');
                          } else {
                            EasyLoading.showError(signinController.message);
                            print("Login error");
                          }
                        },
                        child: Container(
                          height: size.height * 0.1,
                          width: size.height * 0.1,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColorManger.babyRedAppcolor,
                          ),
                          child: Center(
                            child: Container(
                              height: size.height * 0.08,
                              width: size.height * 0.08,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColorManger.mainAppColor,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: AppColorManger.white,
                                  size: size.height * 0.03,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

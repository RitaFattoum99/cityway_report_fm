// ignore_for_file: avoid_print

import '/auth/signup/signup_controller.dart';
import '/core/resource/color_manager.dart';
import '/core/resource/size_manger.dart';
import '/auth/signin/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  SignUpController signUpController = Get.put(SignUpController());
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
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
          child: FormBuilder(
            key: formKey,
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
                    signUpController.username = value;
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'الاسم',
                    labelStyle: const TextStyle(
                        color: AppColorManger.greyAppColor, fontSize: 12),
                    hintText: ' ادخل اسمك',
                    prefixIcon: const Icon(
                      Icons.person_2_rounded,
                      color: AppColorManger.mainAppColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: const EdgeInsets.all(12.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ' الاسم مطلوب';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  onChanged: (value) {
                    signUpController.email = value;
                  },
                  controller: emailController,
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
                      return 'البريد الإلكتروني مطلوب';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  onChanged: (value) {
                    signUpController.password = value;
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: const EdgeInsets.all(12.0),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // Toggle the visibility of the password
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
                  ),
                  obscureText: !isPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'كلمة المرور مطلوب';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  onChanged: (value) {
                    signUpController.confirmPassword = value;
                  },
                  controller: passwordConfirmController,
                  decoration: InputDecoration(
                    labelText: 'تأكيد كلمة المرور',
                    labelStyle: const TextStyle(
                        color: AppColorManger.greyAppColor, fontSize: 12),
                    hintText: ' ادخل كلمة المرور',
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: AppColorManger.mainAppColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: const EdgeInsets.all(12.0),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // Toggle the visibility of the password
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: !isConfirmPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'كلمة المرور مطلوب';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppPaddingManger.p10,
                    right: AppPaddingManger.p12,
                    left: AppPaddingManger.p12,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "لديك حساب؟",
                        style: TextStyle(
                          color: AppColorManger.secondaryAppColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignIn(),
                            ),
                          );
                        },
                        child: const Text(
                          "تسجيل دخول",
                          style: TextStyle(
                            color: AppColorManger.mainAppColor,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColorManger.mainAppColor,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
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
                        "إنشاء حساب",
                        style: TextStyle(
                          color: AppColorManger.secondaryAppColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Container(
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
                              child: IconButton(
                                onPressed: () async {
                                  print("name: ${signUpController.username}");
                                  print("email: ${signUpController.email}");
                                  print(
                                      "password: ${signUpController.password}");
                                  print(
                                      "confirmPassword: ${signUpController.confirmPassword}");
                                  await signUpController.doSignUp();
                                  if (signUpController.registerStatus) {
                                    Get.offNamed('create');
                                  }
                                },
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  color: AppColorManger.white,
                                  size: 30,
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

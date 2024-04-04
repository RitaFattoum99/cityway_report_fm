// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import '../signin/signin.dart';
import '/auth/signup/signup_controller.dart';
import '/core/resource/color_manager.dart';
import '/core/resource/size_manager.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final signUpController = Get.put(SignUpController());
  final _formKey = GlobalKey<FormBuilderState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppPaddingManager.p100,
            left: AppPaddingManager.p12,
            right: AppPaddingManager.p12,
            bottom: AppPaddingManager.p12,
          ),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLogo(size),
                SizedBox(height: size.height * 0.05),
                _buildNameField(),
                const SizedBox(height: 16.0),
                _buildEmailField(),
                const SizedBox(height: 16.0),
                _buildPasswordField(),
                const SizedBox(height: 16.0),
                _buildConfirmPasswordField(),
                 _buildSignInRedirect(),
                const SizedBox(height: 50.0),
                _buildSignUpButton(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(Size size) {
    return Center(
      child: SizedBox(
        height: size.height * 0.1,
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: nameController,
      decoration: _inputDecoration(
        label: 'الاسم',
        hint: 'ادخل اسمك',
        icon: Icons.person_2_rounded,
      ),
      validator: (value) => value!.isEmpty ? 'الاسم مطلوب' : null,
      onChanged: (value) => signUpController.username = value,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      decoration: _inputDecoration(
        label: 'البريد الإلكتروني',
        hint: 'ادخل بريدك الإلكتروني',
        icon: Icons.email,
      ),
      validator: (value) => value!.isEmpty ? 'البريد الإلكتروني مطلوب' : null,
      onChanged: (value) => signUpController.email = value,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: !isPasswordVisible,
      decoration: _inputDecoration(
        label: 'كلمة المرور',
        hint: 'ادخل كلمة المرور',
        icon: Icons.lock,
        suffix: IconButton(
          icon:
              Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () =>
              setState(() => isPasswordVisible = !isPasswordVisible),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'كلمة المرور مطلوب' : null,
      onChanged: (value) => signUpController.password = value,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: !isConfirmPasswordVisible,
      decoration: _inputDecoration(
        label: 'تأكيد كلمة المرور',
        hint: 'ادخل كلمة المرور مجدداً',
        icon: Icons.lock,
        suffix: IconButton(
          icon: Icon(isConfirmPasswordVisible
              ? Icons.visibility
              : Icons.visibility_off),
          onPressed: () => setState(
              () => isConfirmPasswordVisible = !isConfirmPasswordVisible),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'تأكيد كلمة المرور مطلوب' : null,
      onChanged: (value) => signUpController.confirmPassword = value,
    );
  }

  Widget _buildSignInRedirect() {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPaddingManager.p10,
        right: AppPaddingManager.p12,
        left: AppPaddingManager.p12,
      ),
      child: Row(
        children: [
          const Text(
            "لديك حساب؟",
            style: TextStyle(
              color: AppColorManager.secondaryAppColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignIn())),
            child: const Text(
              "تسجيل دخول",
              style: TextStyle(
                color: AppColorManager.mainAppColor,
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSignUpButton(Size size) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPaddingManager.p20,
        left: AppPaddingManager.p50,
        right: AppPaddingManager.p12,
        bottom: AppPaddingManager.p12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "إنشاء حساب",
            style: TextStyle(
              color: AppColorManager.secondaryAppColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          _buildCircularButton(size, () async {
            // Handle sign up
            if (_formKey.currentState!.validate()) {
              EasyLoading.show(status: 'يتم التحميل...', dismissOnTap: true);
              await signUpController.doSignUp();
              if (signUpController.registerStatus) {
                EasyLoading.showSuccess(signUpController.message,
                    duration: const Duration(seconds: 2));
                Get.offAllNamed('home');
              } else {
                EasyLoading.showError(signUpController.message);
                print("error registration");
              }
            }
          }),
        ],
      ),
    );
  }

  Widget _buildCircularButton(Size size, VoidCallback onPressed) {
    return Container(
      height: size.height * 0.1,
      width: size.height * 0.1,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColorManager.babyRedAppcolor,
      ),
      child: Center(
        child: Container(
          height: size.height * 0.08,
          width: size.height * 0.08,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColorManager.mainAppColor,
          ),
          child: Center(
            child: IconButton(
              icon: const Icon(
                Icons.arrow_forward,
                color: AppColorManager.white,
                size: 30,
              ),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle:
          const TextStyle(color: AppColorManager.greyAppColor, fontSize: 12),
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColorManager.mainAppColor),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      contentPadding: const EdgeInsets.all(12.0),
      suffixIcon: suffix,
    );
  }
}

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '/auth/signin/signin_controller.dart';
import '/core/resource/color_manager.dart';
import '../../core/resource/size_manager.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final SignInController signinController = Get.put(SignInController());
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;

  // Email validation regex
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  // Password minimum length (you can adjust this)
  final int passwordMinLength = 8;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _buildSignInForm(context),
      ),
    );
  }

  Widget _buildSignInForm(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(
        top: AppPaddingManager.p100,
        left: AppPaddingManager.p12,
        right: AppPaddingManager.p12,
        bottom: AppPaddingManager.p12,
      ),
      child: Form(
        key: _formKey, // Combined form key for both email and password

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildLogo(size),
            SizedBox(height: size.height * 0.05),
            _buildEmailFormField(),
            const SizedBox(height: 16.0),
            _buildPasswordFormField(),
            // _buildSignUpPrompt(context),
            const SizedBox(height: 50.0),
            _buildSignInButton(context, size),
          ],
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

  Widget _buildEmailFormField() {
    return TextFormField(
      onChanged: (value) => signinController.email = value,
      controller: phoneController,
      decoration: _inputDecoration('البريد الإلكتروني', Icons.email),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'البريد الإلكتروني مطلوب';
        } else if (!emailRegex.hasMatch(value)) {
          return 'من فضلك أدخل بريد إلكتروني صحيح';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordFormField() {
    return TextFormField(
      onChanged: (value) => signinController.password = value,
      controller: passwordController,
      decoration: _inputDecoration('كلمة المرور', Icons.lock).copyWith(
        suffixIcon: IconButton(
          onPressed: () =>
              setState(() => isPasswordVisible = !isPasswordVisible),
          icon:
              Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      obscureText: !isPasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'كلمة المرور مطلوبة';
        } else if (value.length < passwordMinLength) {
          return 'يجب أن تكون كلمة المرور على الأقل $passwordMinLength أحرف';
        }
        // Add more conditions here if needed
        return null;
      },
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle:
          const TextStyle(color: AppColorManager.greyAppColor, fontSize: 12),
      hintText: ' ادخل $label',
      prefixIcon: Icon(icon, color: AppColorManager.mainAppColor),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      contentPadding: const EdgeInsets.all(12.0),
    );
  }

  /* Widget _buildSignUpPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppPaddingManager.p10,
        right: AppPaddingManager.p12,
        left: AppPaddingManager.p12,
      ),
      child: Row(
        children: <Widget>[
          const Text(
            "لا تملك حساب؟",
            style: TextStyle(
              color: AppColorManager.secondaryAppColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const SignUp())),
            child: const Text(
              "إنشاء حساب جديد",
              style: TextStyle(
                color: AppColorManager.mainAppColor,
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
*/
  Widget _buildSignInButton(BuildContext context, Size size) {
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
            "تسجيل دخول",
            style: TextStyle(
              color: AppColorManager.secondaryAppColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          GestureDetector(
            onTap: () => _performSignIn(),
            child: _buildSignInCircle(size),
          ),
        ],
      ),
    );
  }

  void _performSignIn() async {
    print("email: ${signinController.email}");
    print("password: ${signinController.password}");
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'يتم التحميل...', dismissOnTap: true);
      await signinController.doSignIn();

      if (signinController.loginStatus) {
        EasyLoading.showSuccess(signinController.message,
            duration: const Duration(seconds: 2));
          Get.offNamed('home');
      } else {
        EasyLoading.showError(signinController.message);
        print("Login error");
      }
    }
  }

  Widget _buildSignInCircle(Size size) {
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
            child: Icon(
              Icons.arrow_forward,
              color: AppColorManager.white,
              size: size.height * 0.03,
            ),
          ),
        ),
      ),
    );
  }
}

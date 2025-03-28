import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thaipan_test/src/auth/presentation/signin_controller.dart';
import 'package:thaipan_test/src/auth/presentation/verify_acc_controller.dart';
import 'package:thaipan_test/src/auth/presentation/verify_account.dart';
import 'package:thaipan_test/src/shared/app_button.dart';
import 'package:thaipan_test/src/shared/app_icon.dart';
import 'package:thaipan_test/src/shared/app_text.dart';
import 'package:thaipan_test/src/shared/app_text_field.dart';
import 'package:thaipan_test/src/theme/app_theme.dart';
import 'package:thaipan_test/src/util/app_exception.dart';
import 'package:thaipan_test/src/util/extensions.dart';

class SigninScreen extends ConsumerStatefulWidget {
  static const String signinScreen = '/signinScreen';
  const SigninScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SigninScreenState();
}

class _SigninScreenState extends ConsumerState<SigninScreen> {
  late TextEditingController _phoneNumberController, _passwordController;
  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.handleToast(
      context: context,
      provider: signinControllerProvider,
      onSuccess: () {
        context.showInfo("Signin successful", context);
      },
      onError: () {
        AppException exp =
            ref.read(signinControllerProvider).error as AppException;
        if (exp.message.toLowerCase() == 'phone not confirmed') {
          ref
              .read(resendOtpControllerProvider.notifier)
              .resendOtp(phone: _phoneNumberController.text);
          context.pushNamed(
            VerifyAccountScreen.verifyAccountScreen,
            arguments: _phoneNumberController.text,
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: AppIcon(Icons.arrow_back_ios_rounded, size: 26.sp),
        ),
        backgroundColor: AppTheme.themeColor(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText("Welcome Back!", 30.sp, 8, align: TextAlign.left),
                  SizedBox(height: 10.sp),
                  AppText(
                    "Log in to continue exploring amazing features and stay connected!",
                    19.sp,
                    5,
                    color: AppTheme.colorScheme(context).onSecondary,
                    align: TextAlign.left,
                  ),
                  SizedBox(height: 45.sp),
                  AppTextField(
                    controller: _phoneNumberController,
                    hintText: "Phone number",
                    labelText: "Phone number",
                    inputType: TextInputType.phone,
                  ),
                  SizedBox(height: 15.sp),
                  AppTextField(
                    controller: _passwordController,
                    hintText: "Password",
                    isPassword: true,
                    labelText: "Password",
                    isObscure: isObscure,
                    toggleObscurity: (value) {
                      setState(() {
                        isObscure = !isObscure;
                        value = isObscure;
                      });
                    },
                    onChanged: (v) {
                      setState(() {});
                    },
                    inputType: TextInputType.text,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.sp),
            switch (ref.watch(signinControllerProvider)) {
              AsyncLoading() => CircularProgressIndicator(),
              _ => AppButton(
                onPressed: () {
                  ref
                      .read(signinControllerProvider.notifier)
                      .signup(
                        phone: _phoneNumberController.text,
                        password: _passwordController.text,
                      );
                },
                text: "SignIn",
                enabled:
                    _phoneNumberController.text.length >= 6 &&
                            _passwordController.text.length > 5
                        ? true
                        : false,
              ),
            },
          ],
        ),
      ),
    );
  }

  bool isObscure = true;
}

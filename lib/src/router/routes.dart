import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thaipan_test/src/auth/presentation/create_account.dart';
import 'package:thaipan_test/src/auth/presentation/signin.dart';
import 'package:thaipan_test/src/auth/presentation/verify_account.dart';
import 'package:thaipan_test/src/auth/presentation/welcome_auth_screen.dart';
import 'package:thaipan_test/src/change_theme/change_theme.dart';
import 'package:thaipan_test/src/home/presentation/home_page.dart';
import 'package:thaipan_test/src/page_not_found.dart';

class AppRoutes {
  static Route onGenerateRoute(RouteSettings settings) {
    var argument = settings.arguments;
    return switch (settings.name) {
      WelcomeAuthScreen.welcomeAuthScreen => screenOf(
        screenName: WelcomeAuthScreen(),
      ),
      SigninScreen.signinScreen => screenOf(screenName: const SigninScreen()),
      CreateAccount.createAccount => screenOf(screenName: CreateAccount()),
      HomePage.homePage => screenOf(screenName: HomePage()),
      VerifyAccountScreen.verifyAccountScreen => screenOf(
        screenName: VerifyAccountScreen(phoneNumber: argument as String),
      ),
      ChangeThemeScreen.changeThemeScreen => screenOf(
        screenName: ChangeThemeScreen(),
      ),
      _ => screenOf(screenName: PageNotFound()),
    };
  }
}

PageRoute screenOf({required Widget screenName}) {
  return switch (Platform.isIOS) {
    true => CupertinoPageRoute(builder: (context) => screenName),
    _ => MaterialPageRoute(builder: (context) => screenName),
  };
}

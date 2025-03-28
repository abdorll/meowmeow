import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thaipan_test/src/theme/colors.dart';

class AppTheme extends StateNotifier<ThemeMode> {
  static ColorScheme colorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  static ThemeData themeColor(BuildContext context) {
    return Theme.of(context);
  }

  AppTheme() : super(ThemeMode.dark);

  ///==============[TOGGLE THEME]==============
  ///==============[TOGGLE THEME]==============
  ///==============[TOGGLE THEME]==============
  void toggleTheme({required ThemeMode themeMode}) => state = themeMode;

  ///===========[LIGHT THEME]===========[LIGHT THEME]===========[LIGHT THEME]===========[LIGHT THEME]
  ///===========[LIGHT THEME]===========[LIGHT THEME]===========[LIGHT THEME]===========[LIGHT THEME]
  ///===========[LIGHT THEME]===========[LIGHT THEME]===========[LIGHT THEME]===========[LIGHT THEME]
  ThemeData lightTheme = ThemeData(
    iconTheme: const IconThemeData(size: 20),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.primaryColor),
    scaffoldBackgroundColor: AppColors.lightScaffoldColor,
    primaryColor: Colors.red,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: AppColors.primaryColor,
      primary: AppColors.black,
      onPrimary: AppColors.white,
      onSecondary: AppColors.grey4,

      /// [onSecondary:] AppColors.grey,
      error: AppColors.red,
      secondary: AppColors.secondaryColor,
    ),
  );

  ///===========[DARK THEME]===========[DARK THEME]===========[DARK THEME]===========[DARK THEME]
  ///===========[DARK THEME]===========[DARK THEME]===========[DARK THEME]===========[DARK THEME]
  ///===========[DARK THEME]===========[DARK THEME]===========[DARK THEME]===========[DARK THEME]
  ThemeData darkTheme = ThemeData(
    iconTheme: const IconThemeData(size: 20),
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.primaryColor),
    scaffoldBackgroundColor: AppColors.darkScaffoldColor,
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      onPrimary: AppColors.black,
      seedColor: AppColors.primaryColor,
      primary: AppColors.white,
      onSecondary: AppColors.grey1,

      /// [onSecondary:] AppColors.grey,
      error: AppColors.red,
      secondary: AppColors.secondaryColor,
    ),
    useMaterial3: true,
  );

  /// ==============================[Font Weights]===================
  /// ==============================[Font Weights]===================
  /// ==============================[Font Weights]===================
  static Map<int, FontWeight> fontWeight = {
    0: FontWeight.normal,
    1: FontWeight.w100,
    2: FontWeight.w200,
    3: FontWeight.w300,
    4: FontWeight.w400,
    5: FontWeight.w500,
    6: FontWeight.w600,
    7: FontWeight.w700,
    8: FontWeight.w800,
    9: FontWeight.w900,
    10: FontWeight.bold,
  };
  static TextStyle textStyle(
    context, {
    double? weight,
    double? fontSize,
    Color? color,
    TextDecoration? textDecoration,
  }) {
    return GoogleFonts.montserrat(
      fontWeight: fontWeight[weight],
      fontSize: fontSize,
      decoration: textDecoration,
      color: color??AppTheme.colorScheme(context).primary,
    );
  }
}

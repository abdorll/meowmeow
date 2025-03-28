// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thaipan_test/src/shared/app_icon.dart';
import 'package:thaipan_test/src/theme/app_theme.dart';
import 'package:thaipan_test/src/theme/colors.dart';

class AppTextField extends StatefulWidget {
  AppTextField({
    this.hintText,
    this.onChanged,
    this.isPassword = false,
    required this.controller,
    this.suffixIcon,
    this.radius,
    this.isObscure = false,
    this.labelText,
    this.toggleObscurity,
    this.inputType = TextInputType.text,
    super.key,
  });
  final String? hintText, labelText;
  final double? radius;
  final TextInputType inputType;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool isPassword;
  final void Function(bool isObscure)? toggleObscurity;
  final void Function(String?)? onChanged;
  bool isObscure;
  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      controller: widget.controller,
      cursorColor: AppColors.primaryColor,
      keyboardType: widget.inputType,
      obscureText: widget.isObscure,
      style: AppTheme.textStyle(
        context,
        weight: 8,
        fontSize: 20.sp,
        textDecoration: TextDecoration.none,
      ),
      decoration: InputDecoration(
        fillColor: AppTheme.themeColor(context).scaffoldBackgroundColor,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: 19.sp,
          horizontal: 20.sp,
        ),
        labelText: widget.labelText,
        labelStyle: AppTheme.textStyle(context, weight: 5, fontSize: 19.sp),
        hintText: widget.hintText,
        hintStyle: AppTheme.textStyle(
          context,
          color: AppTheme.colorScheme(context).onSecondary,
          weight: 5,
          fontSize: 19.sp,
        ),
        suffixIcon:
            widget.isPassword == true
                ? IconButton(
                  onPressed: () {
                    widget.toggleObscurity!(widget.isObscure);
                  },
                  icon: AppIcon(
                    widget.isObscure == true
                        ? Icons.visibility
                        : Icons.visibility_off_rounded,
                  ),
                )
                : null,
        suffixIconConstraints: BoxConstraints(
          maxHeight: 37.5.sp,
          maxWidth: 45.sp,
          minHeight: 24.5.sp,
          minWidth: 35.sp,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 100.r),
          borderSide: BorderSide(width: 2, color: AppTheme.colorScheme(context).primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius ?? 100.r),
          borderSide: BorderSide(width: 2, color: AppColors.primaryColor),
        ),
      ),
    );
  }
}

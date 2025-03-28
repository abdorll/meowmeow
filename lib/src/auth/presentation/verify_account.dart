import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:thaipan_test/src/auth/presentation/verify_acc_controller.dart';
import 'package:thaipan_test/src/shared/app_button.dart';
import 'package:thaipan_test/src/shared/app_icon.dart';
import 'package:thaipan_test/src/shared/app_text.dart';
import 'package:thaipan_test/src/theme/app_theme.dart';
import 'package:thaipan_test/src/theme/colors.dart';
import 'package:thaipan_test/src/util/extensions.dart';

class VerifyAccountScreen extends ConsumerStatefulWidget {
  static const String verifyAccountScreen = '/verifyAccountScreen';
  const VerifyAccountScreen({required this.phoneNumber, super.key});
  final String phoneNumber;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends ConsumerState<VerifyAccountScreen> {
  late TextEditingController _otpController;
  @override
  void initState() {
    _otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  int minute = 0, seconds = 0;

  Stream<String> timer() async* {
    while (minute < 1) {
      await Future.delayed(const Duration(seconds: 1));
      seconds++;

      if (seconds == 60) {
        minute++;
        seconds = 0;
      }

      yield "${zeroPrecedes(minute, 1)}:${zeroPrecedes(seconds, 1)}";
    }
  }

  String zeroPrecedes(int numb, int zeroCount) {
    return numb.toString().padLeft(zeroCount + 1, '0');
  }

  @override
  Widget build(BuildContext context) {
    ref.handleToast(
      context: context,
      provider: resendOtpControllerProvider,
      onSuccess: () {
        context.showInfo("Check your SMS inbox", context);
      },
    );
    ref.handleToast(
      context: context,
      provider: verifyOtpControllerProvider,
      onSuccess: () {
        context.showInfo("Signin successful", context);
      },
    );
    final defaultPinTheme = PinTheme(
      height: 56.sp,
      width: 56.sp,
      textStyle: AppTheme.textStyle(
        context,
        fontSize: 20,
        color: AppColors.black,
        weight: 6,
      ),
      decoration: BoxDecoration(),
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
        child: StreamBuilder<String>(
          stream: timer(),
          builder: (context, snapshot) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.sp,
                    vertical: 10.sp,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        "Verify your account",
                        30.sp,
                        8,
                        align: TextAlign.left,
                      ),
                      SizedBox(height: 10.sp),
                      AppText(
                        "Enter the verification code sent to your phone number",
                        19.sp,
                        5,
                        color: AppTheme.colorScheme(context).onSecondary,
                        align: TextAlign.left,
                      ),
                      SizedBox(height: 45.sp),
                      SizedBox(
                        width: double.infinity,
                        height: 62.sp,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.r),
                            border: Border.all(
                              color: AppTheme.colorScheme(context).primary,
                              width: 1.6,
                            ),
                          ),
                          child: Pinput(
                            defaultPinTheme: defaultPinTheme,
                            controller: _otpController,
                            autofocus: true,
                            onChanged: (val) {
                              setState(() {});
                              ref
                                  .read(verifyOtpControllerProvider.notifier)
                                  .restoreState(AsyncData(null));
                            },
                            preFilledWidget: Text(
                              '——',
                              style: AppTheme.textStyle(
                                context,
                                weight: 8,
                                fontSize: 15.sp,
                                color: AppTheme.colorScheme(context).primary,
                              ),
                            ),
                            cursor: SizedBox(
                              width: 23.sp,
                              child: Divider(
                                color: AppColors.primaryColor,
                                thickness: 1.8,
                              ),
                            ),
                            pinputAutovalidateMode:
                                PinputAutovalidateMode.onSubmit,
                            showCursor: true,
                            length: 6, 
                          ),
                        ),
                      ),
                      switch (ref.watch(verifyOtpControllerProvider)
                              is AsyncError &&
                          _otpController.text.length == 6) {
                        true => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10.sp),
                            Row(
                              children: [
                                AppIcon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.red,
                                ),
                                SizedBox(width: 4.sp),
                                AppText(
                                  'Invalid code',
                                  15.sp,
                                  6,
                                  color: AppColors.red,
                                ),
                              ],
                            ),
                          ],
                        ),
                        _ => SizedBox.shrink(),
                      },
                      SizedBox(height: 25.sp),
                      switch (ref.watch(resendOtpControllerProvider)
                          is AsyncLoading) {
                        true => Row(
                          children: [
                            SizedBox.square(
                              dimension: 20.sp,
                              child: CircularProgressIndicator(),
                            ),
                            SizedBox(width: 10.sp),
                            AppText("Resending...", 15.sp, 5),
                          ],
                        ),
                        _ => RichText(
                          text: TextSpan(
                            text: "Didn’t get code ",
                            style: AppTheme.textStyle(
                              context,
                              fontSize: 15.sp,
                              weight: 5,
                              color: AppTheme.colorScheme(context).onSecondary,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    (snapshot.data ?? "").contains("1:")
                                        ? "Send again"
                                        : 'Resend in ${!snapshot.hasData ? "00:00" : snapshot.data!}',
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        if ((snapshot.data ?? "").contains(
                                          "1:",
                                        )) {
                                          setState(() {
                                            minute = 0;
                                            seconds = 0;
                                          });
                                          ref
                                              .read(
                                                resendOtpControllerProvider
                                                    .notifier,
                                              )
                                              .resendOtp(
                                                phone: widget.phoneNumber,
                                              );
                                        }
                                      },
                                style: AppTheme.textStyle(
                                  context,
                                  weight: 7,
                                  textDecoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      },
                    ],
                  ),
                ),
                SizedBox(height: 30.sp),
                switch (ref.watch(verifyOtpControllerProvider)) {
                  AsyncLoading() => CircularProgressIndicator(),
                  _ => AppButton(
                    onPressed: () {
                      ref
                          .read(verifyOtpControllerProvider.notifier)
                          .verifyOtp(
                            phone: widget.phoneNumber,
                            otp: _otpController.text,
                          );
                    },
                    text: "Verify",
                    enabled: _otpController.text.length == 6,
                  ),
                },
              ],
            );
          },
        ),
      ),
    );
  }

  bool isObscure = true;
}

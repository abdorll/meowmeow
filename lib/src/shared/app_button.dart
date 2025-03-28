import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thaipan_test/src/shared/app_text.dart';
import 'package:thaipan_test/src/theme/app_theme.dart';
import 'package:thaipan_test/src/theme/colors.dart';

enum BtnType { white, green }

class AppButton extends StatelessWidget {
  const AppButton({
    this.btnType = BtnType.green,
    required this.onPressed,
    required this.text,
    this.enabled = true,
    super.key,
  });
  final BtnType btnType;
  final String text;
  final bool enabled;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.91.sw,
      child: Stack(
        children: [
          Builder(
            builder: (context) {
              return Column(
                children: [
                  SizedBox(height: 3.sp),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(0.9.sw, 57.sp),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: AppColors.black, width: 2),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      backgroundColor: AppTheme.colorScheme(context).primary,
                    ),
                    child: SizedBox.shrink(),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 3.sp,
            right: 4.sp,
            child: ElevatedButton(
              onPressed:
                  enabled == true
                      ? () {
                        FocusScope.of(context).unfocus();
                        onPressed?.call();
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                fixedSize: Size(0.9.sw, 57.sp),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColors.black, width: 1.5),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                disabledBackgroundColor: AppColors.grey2,
                backgroundColor: switch (btnType) {
                  BtnType.green => AppColors.green,
                  _ => AppColors.white,
                },
              ),
              child: AppText(
                text,
                18.sp,
                9,
                color: enabled == true ? AppColors.black : AppColors.grey1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

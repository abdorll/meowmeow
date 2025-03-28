import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thaipan_test/gen/assets.gen.dart';
import 'package:thaipan_test/src/constants/app_constansts.dart';
import 'package:thaipan_test/src/shared/app_text.dart';
import 'package:thaipan_test/src/theme/app_theme.dart';

class LogoWithTagline extends StatefulWidget {
  const LogoWithTagline({super.key});

  @override
  State<LogoWithTagline> createState() => _LogoWithTaglineState();
}

class _LogoWithTaglineState extends State<LogoWithTagline> {
  final _duration = Duration(seconds: 3);

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isExpanded = true;
      setState(() {});
    });
    return AnimatedOpacity(
      opacity: isExpanded == false ? 0.25 : 1,
      curve: Curves.easeOut,
      duration: Duration(seconds: 4),
      child: SizedBox(
        width: null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 10.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Assets.svgs.logosvg.svg(
                height: isExpanded == false ? 37.5.sp : 75.sp,
              ),
              AppAnimatedText(
                AppConsts.APP_NAME,
                isExpanded == false ? 23.sp : 56.sp,
                6,
                duration: _duration,
              ),
              AppAnimatedText(
                "No texts, no waiting—just quick video calls with real people.",
                isExpanded == false ? 10.sp : 20.sp,
                7,
                duration: _duration,
                color: AppTheme.colorScheme(context).onSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

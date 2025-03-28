import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thaipan_test/gen/assets.gen.dart';
import 'package:thaipan_test/src/auth/presentation/welcome_auth_screen.dart';
import 'package:thaipan_test/src/change_theme/change_theme.dart';
import 'package:thaipan_test/src/constants/app_constansts.dart';
import 'package:thaipan_test/src/home/presentation/home_page_controller.dart';
import 'package:thaipan_test/src/shared/app_icon.dart';
import 'package:thaipan_test/src/shared/app_text.dart';
import 'package:thaipan_test/src/theme/app_theme.dart';
import 'package:thaipan_test/src/theme/colors.dart';
import 'package:thaipan_test/src/util/extensions.dart';

class HomePage extends StatelessWidget {
  static const String homePage = "/homePage";
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return InkWell(
              child: AppIcon(
                Icons.menu,
                color: AppColors.primaryColor,
                size: 30.sp,
              ),
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: AppText('Home', 18.sp, 7),
        centerTitle: true,
        backgroundColor: AppTheme.themeColor(context).scaffoldBackgroundColor,
      ),
      drawer: DrawerWidget(),
      body: Center(child: AppText("Home page", 15.sp, 5)),
    );
  }
}

class DrawerWidget extends ConsumerStatefulWidget {
  const DrawerWidget({super.key});

  @override
  ConsumerState<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends ConsumerState<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    ref.handleToast(
      context: context,
      provider: deleteAccountControllerProvider,
      onSuccess: () {
        context.showSuccess("Account deleted successfully", context);
        context.pushNamed(WelcomeAuthScreen.welcomeAuthScreen);
      },
    );

    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: AppTheme.themeColor(context).scaffoldBackgroundColor,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.sp),
          child: Column(
            children: [
              SizedBox(height: 20.sp),
              Assets.svgs.logosvg.svg(height: 80.sp),
              SizedBox(height: 10.sp),
              AppText(AppConsts.APP_NAME, 30.sp, 7),
              SizedBox(height: 20.sp),
              Divider(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    drawerOption(
                      context,
                      icon: Icons.contrast_outlined,
                      optionName: 'Change theme',
                      onTap: () {
                        context.pushNamed(ChangeThemeScreen.changeThemeScreen);
                      },
                    ),
                    switch (ref.watch(logoutControllerProvider)) {
                      AsyncLoading() => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                        child: Row(
                          children: [
                            SizedBox.square(
                              dimension: 20.sp,
                              child: CircularProgressIndicator(),
                            ),
                            SizedBox(width: 10.sp),
                            AppText("Logging you out...", 18.sp, 5),
                          ],
                        ),
                      ),
                      _ => drawerOption(
                        context,
                        icon: Icons.logout,
                        optionName: 'Logout',
                        textColor: AppColors.red,

                        onTap: () {
                          ref.read(logoutControllerProvider.notifier).logout();
                        },
                      ),
                    },
                    SizedBox(height: 15.sp),
                    Divider(),
                    SizedBox(height: 15.sp),
                    SizedBox(
                      height: 75.sp,
                      child: Center(
                        child: switch (ref.watch(
                          deleteAccountControllerProvider,
                        )) {
                          AsyncLoading() => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.sp),
                            child: Row(
                              children: [
                                SizedBox.square(
                                  dimension: 20.sp,
                                  child: CircularProgressIndicator(),
                                ),
                                SizedBox(width: 10.sp),
                                AppText("Deleting your account...", 18.sp, 5),
                              ],
                            ),
                          ),
                          _ => drawerOption(
                            context,
                            icon: Icons.delete_outlined,
                            optionName: "Delete account",
                            textColor: AppColors.red,
                            backgroundColor: Color.lerp(
                              AppColors.red,
                              AppTheme.colorScheme(context).onPrimary,
                              0.7,
                            ),
                            onTap: () {
                              ref
                                  .read(
                                    deleteAccountControllerProvider.notifier,
                                  )
                                  .deleteAccount();
                            },
                          ),
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget drawerOption(
  BuildContext context, {
  required IconData icon,
  required String optionName,
  required VoidCallback onTap,
  Color? backgroundColor,
  Color? textColor,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 15.sp),
    child: Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
            backgroundColor:
                backgroundColor ??
                AppTheme.themeColor(context).scaffoldBackgroundColor,
          ),
          onPressed: () {
            onTap();
          },
          child: Row(
            children: [
              AppIcon(icon, size: 23.sp, color: textColor),
              SizedBox(width: 10.sp),
              AppText(
                optionName,
                16.sp,
                5,
                color: textColor ?? AppTheme.colorScheme(context).primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}

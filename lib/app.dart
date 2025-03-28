import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show ScreenUtilInit;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thaipan_test/src/auth/presentation/welcome_auth_screen.dart';
import 'package:thaipan_test/src/constants/app_constansts.dart';
import 'package:thaipan_test/src/router/auth_state_nav_observer.dart';
import 'package:thaipan_test/src/router/routes.dart';
import 'package:thaipan_test/src/theme/app_theme.dart';
import 'package:thaipan_test/src/util/utils.dart';
import 'package:toastification/toastification.dart';

final themeProvider = StateNotifierProvider<AppTheme, ThemeMode>((ref) {
  return AppTheme();
});

AppTheme appTheme = AppTheme();

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late AuthStateNavObserver authNavObserver;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () {
      authNavObserver = AuthStateNavObserver(ref);
      authNavObserver.listen();
    });
    super.initState();
  }

  @override
  void dispose() {
    authNavObserver.disposeObserver();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigatorKey = ref.watch(navigatorKeyProvider);
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Builder(
          builder: (context) {
            return ValueListenableBuilder<Box>(
              valueListenable: Utils.appCacheBox!.listenable(),
              builder: (context, box, widget) {
                String theme = box.get(
                  AppConsts.THEME_MODE_KEY,
                  defaultValue: AppConsts.SYSTEM_THEME_KEY,
                );
                return ToastificationWrapper(
                  child: MaterialApp(
                    navigatorKey: navigatorKey,
                    title: AppConsts.APP_NAME,
                    theme: appTheme.lightTheme,
                    navigatorObservers: [AuthStateNavObserver(ref)],
                    darkTheme: appTheme.darkTheme,
                    themeMode: switch (theme) {
                      AppConsts.DARK_THEME_KEY => ThemeMode.dark,
                      AppConsts.LIGHT_THEME_KEY => ThemeMode.light,
                      AppConsts.SYSTEM_THEME_KEY => ThemeMode.system,
                      _ => ThemeMode.system,
                    },
                    debugShowCheckedModeBanner: false,
                    initialRoute: WelcomeAuthScreen.welcomeAuthScreen,
                    onGenerateRoute: AppRoutes.onGenerateRoute,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
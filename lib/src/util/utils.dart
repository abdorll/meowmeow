import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thaipan_test/src/constants/app_constansts.dart';

class Utils {
  static Future initApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    await Supabase.initialize(
      url: AppConsts.SUPABASE_PROJECT_URL,
      anonKey: AppConsts.SUPABSE_ANON_KEY,
    );
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    appCacheBox = await Hive.openBox(AppConsts.APP_CACHE_BOX);
  }

  static Box? appCacheBox;
}

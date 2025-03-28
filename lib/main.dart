import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thaipan_test/app.dart';
import 'package:thaipan_test/src/util/utils.dart';

void main() async {
  await Utils.initApp();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return App();
  }
}

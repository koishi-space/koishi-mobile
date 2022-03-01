import 'package:flutter/material.dart';
import 'package:koishi/get/app_controller.dart';
import 'package:koishi/pages/splash_screen.dart';
import 'package:get/get.dart';
import 'package:koishi/theme/main_theme.dart';

void main() {
  // Init GetX controllers
  Get.put(AppController());

  runApp(GetMaterialApp(
    title: "Koishi",
    home: const SplashScreen(),
    theme: KoishiTheme.defaultTheme,
  ));
}

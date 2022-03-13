import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:get/get.dart";
import 'package:koishi/models/collection.dart';

import '../models/user.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  var appInitFailed = false.obs;
  var appInitFailMessage = "".obs;
  var serverUrl = "".obs;
  var apiToken = "".obs;
  var collections = List<Collection>.empty(growable: true).obs;
  var appVersion = "".obs;
  User? user;

  static void setAndroidOverlayColor(String color) {
    switch (color) {
      case "white":
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white, // navigation bar color
            statusBarColor: Colors.white, // status bar color
          ),
        );
        break;
      case "whitesmoke":
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Color(0xFFf5f5f5), // navigation bar color
            statusBarColor: Color(0xFFf5f5f5), // status bar color
          ),
        );
        break;
    }
  }
}

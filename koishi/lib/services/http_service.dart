import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:koishi/get/app_controller.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

class HttpService {
  static Map<String, String> getHeaders() {
    return {
      "x-auth-token": AppController.to.apiToken.string,
      'Content-type': 'application/json',
    };
  }

  static Uri endpointUri(String route, String endpoint) {
    String protocol = AppController.to.serverUrl.string.split(":")[0];
    if (protocol == "https") {
      String authority =
          AppController.to.serverUrl.string.replaceAll("https://", "");
      return Uri.https(authority, route + endpoint);
    } else {
      String authority =
          AppController.to.serverUrl.string.replaceAll("http://", "");
      return Uri.http(authority, route + endpoint);
    }
  }

  static Future<bool> checkInternetConnection() async {
    var conn = await (Connectivity().checkConnectivity());

    if (conn == ConnectivityResult.none) {
      Get.snackbar("No internet", "Connect to the internet and try again.");
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> checkInternetConnectionWithDialog(
      Function callback) async {
    var conn = await (Connectivity().checkConnectivity());

    if (conn == ConnectivityResult.none) {
      Get.dialog(
          AlertDialog(
            title: const Text(
              'No internet',
              style: TextStyle(
                color: Color(0xFF1138f7),
              ),
            ),
            content: const Text("Connect to the internet and try again"),
            actions: [
              TextButton(
                onPressed: () async {
                  Get.back();
                  io.exit(0);
                }, // Close the dialog
                child: const Text(
                  'Exit',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  callback();
                }, // Close the dialog
                child: const Text(
                  'Try again',
                  style: TextStyle(
                    color: Color(0xFF1138f7),
                  ),
                ),
              ),
            ],
          ),
          barrierDismissible: false);
      return false;
    } else {
      return true;
    }
  }
}

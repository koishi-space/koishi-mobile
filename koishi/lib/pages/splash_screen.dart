import 'package:flutter/material.dart';
import 'package:koishi/get/app_controller.dart';
import 'package:koishi/pages/collections_overview_screen.dart';
import 'package:koishi/pages/login_screen.dart';
import 'package:koishi/pages/server_screen.dart';
import 'package:koishi/services/app_init_service.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _initApp() {
    Future.delayed(Duration.zero, () => AppInitService.onStartInit()).then((v) {
      // If server_url is null, show server selection page
      if (AppController.to.serverUrl.string == "") {
        return Get.off(() => const ServerScreen(),
            transition: Transition.noTransition);
      }

      // If api_token is null, show login screen
      if (AppController.to.apiToken.string == "") {
        return Get.off(() => const LoginScreen(),
            transition: Transition.noTransition);
      }

      return Get.off(() => const CollectionsOverviewScreen(),
          transition: Transition.noTransition);
    });
  }

  @override
  void initState() {
    AppController.setAndroidOverlayColor("white");
    _initApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(),
            Image.asset(
              'assets/images/koishiLogo.png',
              fit: BoxFit.contain,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}

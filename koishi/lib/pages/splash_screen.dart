import 'package:flutter/material.dart';
import 'package:koishi/get/app_controller.dart';
import 'package:koishi/pages/collections_overview_screen.dart';
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
    Future.delayed(
            const Duration(seconds: 2), () => AppInitService.onStartInit())
        .then((v) {
      // If server_url is null, show server selection page
      if (AppController.to.serverUrl.string == "" ||
          AppController.to.apiToken.string == "") {
        return Get.off(() => const ServerScreen(),
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

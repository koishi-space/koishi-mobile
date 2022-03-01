import 'package:flutter/material.dart';
import 'package:koishi/get/app_controller.dart';

class CollectionsOverviewScreen extends StatefulWidget {
  const CollectionsOverviewScreen({Key? key}) : super(key: key);

  @override
  _CollectionsOverviewScreenState createState() =>
      _CollectionsOverviewScreenState();
}

class _CollectionsOverviewScreenState extends State<CollectionsOverviewScreen> {
  @override
  void initState() {
    AppController.setAndroidOverlayColor("white");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Yooo, welcome " + AppController.to.user!.name),
      ),
    );
  }
}

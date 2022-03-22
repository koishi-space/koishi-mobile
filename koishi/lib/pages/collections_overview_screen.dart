import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koishi/get/app_controller.dart';
import 'package:koishi/models/collection.dart';
import 'package:koishi/pages/profile_screen.dart';
import 'package:koishi/services/http_service.dart';
import 'package:koishi/services/koishi_api/collections_service.dart';
import 'package:koishi/widgets/collection_card.dart';
import 'package:url_launcher/url_launcher.dart';

class CollectionsOverviewScreen extends StatefulWidget {
  const CollectionsOverviewScreen({Key? key}) : super(key: key);

  @override
  _CollectionsOverviewScreenState createState() =>
      _CollectionsOverviewScreenState();
}

class _CollectionsOverviewScreenState extends State<CollectionsOverviewScreen> {
  bool loading = true;
  List<Collection> collections = List<Collection>.empty(growable: true);

  Future<void> _loadCollections() async {
    if (!(await HttpService.checkInternetConnectionWithDialog(
        _loadCollections))) return;
    setState(() {
      loading = true;
    });
    List<Collection> freshData = await KoishiApiCollectionsService.getAll();
    setState(() {
      loading = false;
      collections = freshData;
    });
  }

  Future<void> _showUpdateDialog() async {
    AppController.to.updateNotified.value = true;
    return await Get.dialog(AlertDialog(
      title: Text(
        'Update available',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      content: const Text("There is a new update available. Update now?"),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          }, // Close the dialog
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        TextButton(
            onPressed: () async {
              Get.back();
              await launch(AppController.to.latestRelease["url"]!);
            }, // Close the dialog
            child: Text(
              'Update',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ))
      ],
    ));
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async => _loadCollections());
    AppController.setAndroidOverlayColor("white");

    if (AppController.to.updateAvailable.value &&
        !AppController.to.updateNotified.value) {
      Future.delayed(const Duration(milliseconds: 1), _showUpdateDialog);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const ProfileScreen()),
            icon: const Icon(Icons.account_circle),
            color: Colors.black,
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 5),
              child: Image.asset(
                "assets/images/koishiLogo.png",
                fit: BoxFit.scaleDown,
                height: 28,
                width: 28,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: Text(
                "Koishi",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
      body: (!loading)
          ? RefreshIndicator(
              onRefresh: _loadCollections,
              color: Theme.of(context).primaryColor,
              child: ListView.builder(
                itemCount: collections.length,
                itemBuilder: (context, index) {
                  return CollectionCard(
                    collection: collections[index],
                    isFirst: index == 0,
                  );
                },
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

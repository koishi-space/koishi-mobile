import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koishi/get/app_controller.dart';
import 'package:koishi/models/collection.dart';
import 'package:koishi/pages/profile_screen.dart';
import 'package:koishi/services/koishi_api/collections_service.dart';
import 'package:koishi/widgets/collection_card.dart';

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
    setState(() {
      loading = true;
    });
    List<Collection> freshData = await KoishiApiCollectionsService.getAll();
    setState(() {
      loading = false;
      collections = freshData;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async => _loadCollections());
    AppController.setAndroidOverlayColor("white");
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

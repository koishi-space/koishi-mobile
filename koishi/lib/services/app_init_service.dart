import 'package:connectivity/connectivity.dart';
import 'package:get_storage/get_storage.dart';
import 'package:koishi/get/app_controller.dart';
import 'package:koishi/services/github_api/releases_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/user.dart';

class AppInitService {
  static Future onStartInit() async {
    // Initialize GetX storage
    await GetStorage.init();

    // Set the default values
    await GetStorage().writeIfNull("server_url", "");
    await GetStorage().writeIfNull("api_token", "");

    // Read and load app config from GetX storage
    AppController.to.serverUrl.value = GetStorage().read("server_url") ?? "";
    AppController.to.apiToken.value = GetStorage().read("api_token") ?? "";
    if (GetStorage().hasData("user")) {
      AppController.to.user = User.fromJson(GetStorage().read("user"));
    }

    // Get the app info (version and build)
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppController.to.appVersion.value =
        "v${packageInfo.version} build${packageInfo.buildNumber}";

    // Check if there is an update available
    var conn = await (Connectivity().checkConnectivity());
    if (conn != ConnectivityResult.none) {
      var latestRelease = await GithubApiReleasesService.getLatestRelease();
      AppController.to.latestRelease = latestRelease;
      if (latestRelease["name"] != packageInfo.version) {
        AppController.to.updateAvailable.value = true;
      }
    }
  }
}

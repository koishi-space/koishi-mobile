import 'package:get_storage/get_storage.dart';
import 'package:koishi/get/app_controller.dart';

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
  }
}

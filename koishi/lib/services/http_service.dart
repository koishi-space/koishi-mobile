import 'package:koishi/get/app_controller.dart';

class HttpService {
  static Map<String, String> getHeaders() {
    return {
      "x-auth-token": AppController.to.apiToken.string,
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
}

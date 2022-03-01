import 'package:http/http.dart' as http;
import 'package:koishi/services/http_service.dart';

class KoishiApiPingService {
  KoishiApiPingService._internal();

  static final KoishiApiPingService _koishiApiPingService =
      KoishiApiPingService._internal();
  static KoishiApiPingService get to => _koishiApiPingService;

  static const String route = "/ping";

  static Future<String> getServerStatus() async {
    try {
      http.Response res = await http.get(HttpService.endpointUri(route, ""));
      if (res.statusCode == 200) {
        return "Connected";
      } else {
        throw "Failed to connect";
      }
    } catch (ex) {
      throw "Failed to connect";
    }
  }
}

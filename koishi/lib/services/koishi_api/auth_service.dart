import "package:http/http.dart" as http;
import 'package:koishi/services/http_service.dart';

class KoishiApiAuthService {
  KoishiApiAuthService._internal();

  static final KoishiApiAuthService _koishiApiAuthService =
      KoishiApiAuthService._internal();
  static KoishiApiAuthService get to => _koishiApiAuthService;

  static const String route = "/auth";

  static Future<String> login(String email, String password) async {
    Map<String, String> credentials = {
      "email": email,
      "password": password,
    };

    http.Response res =
        await http.post(HttpService.endpointUri(route, ""), body: credentials);
    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw res.body;
    }
  }
}

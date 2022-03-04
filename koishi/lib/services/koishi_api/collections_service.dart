import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:koishi/models/collection.dart';
import 'package:koishi/services/http_service.dart';

class KoishiApiCollectionsService {
  KoishiApiCollectionsService._internal();

  static final KoishiApiCollectionsService _koishiApiCollectionsService =
      KoishiApiCollectionsService._internal();
  static KoishiApiCollectionsService get to => _koishiApiCollectionsService;

  static const String route = "/collections";

  static Future<List<Collection>> getAll() async {
    http.Response res = await http.get(HttpService.endpointUri(route, ""),
        headers: HttpService.getHeaders());
    List<Collection> collections = [];

    List<dynamic> payload = jsonDecode(res.body);
    collections.addAll(payload.map((e) => Collection.fromJson(e)).toList());
    return collections;
  }
}

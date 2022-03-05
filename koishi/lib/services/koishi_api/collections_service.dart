import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:koishi/models/collection.dart';
import 'package:koishi/models/collection_model.dart';
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

  static Future<CollectionModel> getModel(String collectionId) async {
    http.Response res = await http.get(
        HttpService.endpointUri(route, "/$collectionId/model"),
        headers: HttpService.getHeaders());

    if (res.statusCode == 200) {
      return CollectionModel.fromJson(jsonDecode(res.body));
    } else {
      throw "API error"; // TODO: implement http error handling
    }
  }

  static Future<String> addRow(
    String collectionId,
    List<dynamic> payload,
  ) async {
    http.Response res = await http.post(
        HttpService.endpointUri(route, "/$collectionId/data"),
        body: jsonEncode(payload),
        headers: HttpService.getHeaders());

    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw "API error"; // TODO: implement http error handling
    }
  }
}

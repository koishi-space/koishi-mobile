import 'dart:convert';

import "package:http/http.dart" as http;

class GithubApiReleasesService {
  GithubApiReleasesService._internal();

  static final GithubApiReleasesService _githubApiReleasesService =
      GithubApiReleasesService._internal();

  static GithubApiReleasesService get to => _githubApiReleasesService;

  static String githubUrlAuthority = "api.github.com";
  static String githubUrlEndpoint =
      "/repos/hendrychjan/koishi-mobile/releases/latest";

  static Future<Map<String, String>> getLatestRelease() async {
    Uri uri = Uri.https(githubUrlAuthority, githubUrlEndpoint);
    http.Response res = await http.get(uri);

    if (res.statusCode == 200) {
      var decoded = jsonDecode(res.body);
      return {"name": decoded["name"], "url": decoded["html_url"]};
    } else {
      throw "GitHub API error"; // TODO: implement http error handling
    }
  }
}

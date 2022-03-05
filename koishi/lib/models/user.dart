import 'package:get_storage/get_storage.dart';

import '../get/app_controller.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String status;
  final bool isAdmin;

  User(this.id, this.name, this.email, this.status, this.isAdmin);

  User.fromJson(Map<String, dynamic> json)
      : id = json["_id"],
        name = json["name"],
        email = json["email"],
        status = json["status"],
        isAdmin = json["isAdmin"];

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'status': status,
        'isAdmin': isAdmin,
      };

  void login() async {
    AppController.to.user = this;
    await GetStorage().write("user", this);
  }

  void logout() async {
    AppController.to.apiToken.value = "";
    AppController.to.user = null;
    await GetStorage().remove("user");
    await GetStorage().remove("api_token");
  }

  static User getLocalUser() {
    return (GetStorage().read("user") as User);
  }
}

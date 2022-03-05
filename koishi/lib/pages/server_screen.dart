import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:koishi/get/app_controller.dart';
import 'package:koishi/pages/login_screen.dart';
import 'package:koishi/services/koishi_api/ping_service.dart';

class ServerScreen extends StatefulWidget {
  const ServerScreen({Key? key}) : super(key: key);

  @override
  _ServerScreenState createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  final TextEditingController _serverInputController = TextEditingController();
  final GlobalKey<FormState> _serverScreenFormKey = GlobalKey<FormState>();
  String connectionErrorMessage = "";
  bool connectionFailed = false;
  bool loading = false;

  @override
  void initState() {
    AppController.setAndroidOverlayColor("whitesmoke");
    _serverInputController.text = AppController.to.serverUrl.string;
    super.initState();
  }

  @override
  void dispose() {
    _serverInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Heading - "Koishi"
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Text(
                  "Koishi",
                  style: Theme.of(context).textTheme.headline1!,
                ),
              ),

              // Heading - "Connect to a server"
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  "Connect to a server",
                  style: Theme.of(context).textTheme.headline2!,
                ),
              ),

              // Server url input
              Form(
                key: _serverScreenFormKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: TextFormField(
                        controller: _serverInputController,
                        decoration: const InputDecoration(
                          hintText: "Server url",
                        ),
                        cursorColor: Colors.black,
                        validator: (String? value) {
                          // Required
                          if (value == null || value.isEmpty) {
                            return "This field cannot be empty";
                          }

                          // http / https pattern
                          String urlPattern = r'^(http|https)://';
                          RegExp urlRegExp = RegExp(urlPattern);
                          if (!urlRegExp.hasMatch(value)) {
                            return "Please enter a valid url";
                          }
                          return null;
                        },
                      ),
                    ),

                    // Button "Connect"
                    (!loading)
                        ? ElevatedButton(
                            onPressed: () async {
                              if (_serverScreenFormKey.currentState!
                                  .validate()) {
                                setState(() {
                                  loading = true;
                                });

                                // Save the server url
                                AppController.to.serverUrl.value =
                                    _serverInputController.text;
                                // Get the connection status
                                try {
                                  await KoishiApiPingService.getServerStatus();
                                  await GetStorage().write("server_url",
                                      AppController.to.serverUrl.string);
                                  Get.to(() => const LoginScreen(),
                                      transition: Transition.rightToLeft);
                                } catch (ex) {
                                  setState(() {
                                    connectionFailed = true;
                                    connectionErrorMessage = ex.toString();
                                  });
                                }

                                setState(() {
                                  loading = false;
                                });
                              }
                            },
                            child: const Text("Connect"))
                        : const CircularProgressIndicator(),
                  ],
                ),
              ),
              if (connectionFailed)
                Text(
                  connectionErrorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

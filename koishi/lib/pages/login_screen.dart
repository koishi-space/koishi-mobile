import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:koishi/get/app_controller.dart';
import 'package:koishi/pages/collections_overview_screen.dart';
import 'package:koishi/services/koishi_api/auth_service.dart';

import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginScreenFormKey = GlobalKey<FormState>();
  final TextEditingController _emailInputController = TextEditingController();
  final TextEditingController _passwordInputController =
      TextEditingController();
  String loginErrorMessage = "";
  bool loginFailed = false;
  bool loading = false;

  @override
  void initState() {
    AppController.setAndroidOverlayColor("whitesmoke");
    super.initState();
  }

  @override
  void dispose() {
    _emailInputController.dispose();
    _passwordInputController.dispose();
    super.dispose();
  }

  void handleSubmitLogin() async {
    if (_loginScreenFormKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      try {
        // Auth the user, retrieve the API token and save it to local storage
        String token = await KoishiApiAuthService.login(
            _emailInputController.text, _passwordInputController.text);
        AppController.to.apiToken.value = token;
        await GetStorage().write("api_token", token);

        // Decode the jwt token to a User object
        User user = User.fromJson(Jwt.parseJwt(token));
        user.login();

        // Navigate to CollectionsOverview screen
        Get.off(() => const CollectionsOverviewScreen(),
            transition: Transition.fadeIn);
      } catch (ex) {
        setState(() {
          loginFailed = true;
          loginErrorMessage = ex.toString();
        });
      }

      setState(() {
        loading = false;
      });
    }
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

              // Heading - "Log in"
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  "Log in",
                  style: Theme.of(context).textTheme.headline2!,
                ),
              ),

              Form(
                key: _loginScreenFormKey,
                child: Column(
                  children: [
                    // Email input
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailInputController,
                        decoration: const InputDecoration(
                          hintText: "Email",
                        ),
                        cursorColor: Colors.black,
                        validator: (String? value) {
                          // Required
                          if (value == null || value.isEmpty) {
                            return "This field cannot be empty";
                          }

                          // Email pattern
                          String emailPattern =
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                          RegExp emailRegExp = RegExp(emailPattern);
                          if (!emailRegExp.hasMatch(value)) {
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                      ),
                    ),

                    // Password input
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        obscureText: true,
                        controller: _passwordInputController,
                        decoration: const InputDecoration(
                          hintText: "Password",
                        ),
                        cursorColor: Colors.black,
                        validator: (String? value) {
                          // Required
                          if (value == null || value.isEmpty) {
                            return "This field cannot be empty";
                          }

                          // Min 8 characters
                          if (value.length < 8) {
                            return "Password has to be at least 8 chars";
                          }
                          return null; // ...valid
                        },
                      ),
                    ),

                    // Button "Log in"
                    (!loading)
                        ? Column(
                            children: [
                              ElevatedButton(
                                onPressed: handleSubmitLogin,
                                child: const Text("Log in"),
                              ),
                              if (loginFailed)
                                Text(
                                  loginErrorMessage,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(Icons.arrow_back_ios),
                              ),
                            ],
                          )
                        : const CircularProgressIndicator(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

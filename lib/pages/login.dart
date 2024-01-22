import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:outsource_mobile/data/AuthData.dart';
import 'package:outsource_mobile/data/Storage.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  final _storage = Storage();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  String loginException = "";
  String passwordException = "";


  Future<bool> updateAndSendData() {
    if (validateData(loginController.text, passwordController.text)) {
      return sendValues(loginController.text, passwordController.text);
    }
    return Future<bool>.value(false);
  }

  bool validateData(String login, String password) {
    return true;
  }

  Future<bool> sendValues(String login, String password) async{
    if (kDebugMode) {
      print("Sending login: $login and password: $password");
    }
    final response = await http.post(
        Uri.parse("${const String.fromEnvironment("BASE_URL")}/api/Auth/authenticate"),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String> {
          "userName": login,
          "password": password
        })
    );
    if (kDebugMode) {
      print(response.request);
      print(response.headers);
      print(response.body);
    }
    if (response.statusCode == 200) {
      var data = AuthData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      _storage.addNewItem("token", data.token, data.username);
      _storage.addNewItem("refreshToken", data.token, data.username);
      _storage.addNewItem("username", data.username, data.username);
      return true;
    }
    else {
      if (kDebugMode) {
        print("Something went wrong! Request failed!");
      }
      return false;
    }

    //here wil sending values
    //Navigator.push(context, MaterialPageRoute(builder: builder))
  }

  @override
  void dispose() {
    loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          SingleChildScrollView(
      child:
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 35),
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const ImageIcon(
                AssetImage("assets/img/logo.png"),
                size: 140,
              ),

              const Text(
                'Вход',
                textAlign: TextAlign.left,
                style:
                TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 30,),
              FractionallySizedBox(
                widthFactor: 0.8,
                child:
                TextField(
                  controller: loginController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Логин',
                  ),
                )
              ),
              const SizedBox(height: 25,),
              FractionallySizedBox(
                  widthFactor: 0.8,
                  child:
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Пароль',
                    ),
                  )
              ),
              const SizedBox(height: 25,),
              TextButton(

                  onPressed: () {
                    // if (updateAndSendData()) {
                    //   context.goNamed("MyProjects");
                    // }
                    updateAndSendData().then((value) => {
                      if (value == true)
                        context.goNamed("MyProjects")
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 55)
                  ),
                  child: const Text("Войти", style: TextStyle(color: Colors.white),)
              ),



            ],
          ),
        )
      )
    );
  }
}

// class FocusLogo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//     )
//   }
//
// }

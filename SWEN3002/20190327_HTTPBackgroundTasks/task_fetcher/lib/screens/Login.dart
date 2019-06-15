import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:task_fetcher/main.dart';
import 'package:task_fetcher/serializers/request/LoginSession.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}



class _LoginState extends State<StatefulWidget> {
  TextEditingController _usernameField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    dio.onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Task Fetcher"),
          ],
        ),
      ),
      body: Center(
        child: new ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 20,
                  color: themeColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: TextField(
                controller: _usernameField,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor,
                      width: 1.0,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: themeColor,
                  ),
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: TextField(
                controller: _passwordField,
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeColor,
                      width: 1.0,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: themeColor,
                  ),
                  labelText: 'Password',
                ),
              ),
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: RaisedButton(
                color: themeColor,
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  await showCustomProcessDialog(
                    "Signing In..",
                    context,
                    dissmissable: true,
                  );
                  await Future.delayed(Duration(seconds: 2));
                  Response loginResponse;
                  try {
                    loginResponse = await dio.get(
                      serverIp + ServerAPI.tasks,
                      data: new LoginSession(
                        username: _usernameField.text,
                        password: _passwordField.text,
                      ).toJSON(),
                    );
                  } catch (err) {
                    Navigator.pop(context);
                    toastMessageBottomShort("Error Occurred", context);
                    return null;
                  }
                  Navigator.pop(context);
                  switch (loginResponse.statusCode) {
                    case 200:
                      toastMessageBottomShort("Login Successful", context);
                      currentUser = new LoginSession(
                        username: _usernameField.text,
                        password: _passwordField.text,
                      );
                      _usernameField.text = _passwordField.text = "";
                      Navigator.pushReplacementNamed(context, RouteMapper.home);
                      break;
                    default:
                      toastMessageBottomShort("Login Failed", context);
                      break;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

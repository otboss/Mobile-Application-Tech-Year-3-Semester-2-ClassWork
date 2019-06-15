import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:task_fetcher/main.dart';
import 'package:task_fetcher/serializers/request/LoginSession.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<StatefulWidget> {
  TextEditingController _usernameField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  TextEditingController _confirmPasswordField = TextEditingController();  
  FocusNode _incorrectConfirmationPasswordFocus;
  
  @override
  void dispose() {
    _incorrectConfirmationPasswordFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _incorrectConfirmationPasswordFocus = FocusNode();
  }

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
                "Sign Up",
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
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: TextField(
                focusNode: _incorrectConfirmationPasswordFocus,
                controller: _confirmPasswordField,
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
                  labelText: 'Confirm Password',
                ),
              ),
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: RaisedButton(
                color: themeColor,
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  await showCustomProcessDialog(
                    "Please Wait",
                    context,
                    dissmissable: true,
                  );
                  await Future.delayed(Duration(seconds: 2));
                  Response registrationResponse;
                  dynamic registrationSuccessful;
                  try {
                    if(_passwordField.text == _confirmPasswordField.text){
                      registrationResponse = await dio.get(
                        serverIp + ServerAPI.register,
                        data: new LoginSession(
                          username: _usernameField.text,
                          password: _passwordField.text,
                        ).toJSON(),
                      );                      
                    }
                    else{
                      Navigator.pop(context);
                      toastMessageBottomShort("Password Mismatch", context);
                      FocusScope.of(context).requestFocus(_incorrectConfirmationPasswordFocus);
                      return null;
                    }
                  } catch (err) {
                    Navigator.pop(context);
                    toastMessageBottomShort("Error Occurred", context);
                    return null;
                  }
                  registrationSuccessful = registrationResponse.data["success"];
                  if(registrationSuccessful == null)
                    registrationSuccessful = false;
                  if(registrationSuccessful){
                    toastMessageBottomShort("Registration Successful", context);
                    _usernameField.text = _passwordField.text = _confirmPasswordField.text = "";
                    Navigator.pushReplacementNamed(context, RouteMapper.login);
                  }
                  else{
                    Navigator.pop(context);
                    toastMessageBottomShort("Error Occurred", context);
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

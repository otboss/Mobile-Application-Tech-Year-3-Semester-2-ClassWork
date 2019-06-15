import 'package:dio/dio.dart';
import 'package:task_fetcher/screens/Register.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:task_fetcher/screens/Home.dart';
import 'package:task_fetcher/screens/Login.dart';
import 'package:task_fetcher/serializers/request/LoginSession.dart';

void main() => runApp(MyApp());

//Global Variables
Color themeColor = Colors.blue;
Dio dio = Dio(Options(connectTimeout: 5000, receiveTimeout: 5000));
String serverIp = "https://192.168.3.16:5000/";
LoginSession currentUser;

///The endpoints of the REST API
abstract class ServerAPI{
  static String tasks = "todo/api/v1.0/tasks/";
  //TODO: Implement Registration endpoint on backend
  static String register = "register/";
}

Future<bool> showCustomProcessDialog(String text, BuildContext context, {bool dissmissable, TextAlign alignment}) async {
  if (dissmissable == null) 
    dissmissable = false;
  if (alignment == null) 
    alignment = TextAlign.left;
  Widget customDialog = AlertDialog(
    title: Text(
      text,
      textAlign: alignment,
    ),
    content: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Column(
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: themeColor,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    ),
    actions: <Widget>[],
  );
  showDialog(context: context, child: customDialog, barrierDismissible: dissmissable);
  return true;
}

Future<bool> toastMessageBottomShort(String message, BuildContext context) async {
  Toast.show(message, context, duration: 4, gravity: Toast.BOTTOM);
  return true;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Fetcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
      routes: {
        "/home": (BuildContext context) => Home(),
        "/login": (BuildContext context) => Login(),
        "/register": (BuildContext context) => Register(),
      },
    );
  }
}

///The route mapper for the application. Defines all the app's
///navigation routes in one place
abstract class RouteMapper{
  static String home = "/home";
  static String login = "/login";
  static String register = "/register";
}

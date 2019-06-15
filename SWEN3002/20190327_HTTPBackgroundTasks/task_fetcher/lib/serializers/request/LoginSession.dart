import 'package:meta/meta.dart';

///The object that will be used to store the users credentials
///to be used to authenticate requests
class LoginSession{
  final String username;
  final String password;
  LoginSession({@required this.username, @required this.password});
  Map toJSON(){
    return {
      "task_id": "",
      "username": this.username,
      "password": this.password
    };
  }
}
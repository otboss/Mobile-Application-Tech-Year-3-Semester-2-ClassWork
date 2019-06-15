import 'package:meta/meta.dart';
import './LoginSession.dart';

///Creates an object for requesting 
abstract class TaskRequest{
  static Map toJSON({@required LoginSession userSession, @required String taskId}){
    Map tmp = userSession.toJSON();
    tmp.addAll({
      "task_id": taskId
    });
    return tmp;
  }
}
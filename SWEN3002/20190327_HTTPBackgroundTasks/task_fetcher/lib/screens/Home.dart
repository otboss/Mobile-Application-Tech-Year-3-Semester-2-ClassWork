import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:task_fetcher/main.dart';
import 'package:task_fetcher/serializers/request/TaskRequest.dart';
import 'package:task_fetcher/serializers/response/Task.dart';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<StatefulWidget> {
  bool _searchOn = false;
  Task _currentTask = Task(id: -1, description: "", title: "", done: false);
  List<Widget> _searchViewResults = [];
  EdgeInsets _cellPadding = EdgeInsets.fromLTRB(10, 10, 10, 10);
  Widget _notSignedInMessage = Container();
  Widget _searchResultsStack = Text("");
  Widget _addUserBtn;

  ///The message to be shown when the searchbar is empty
  Widget _emptySearchQueryPlaceholder = Center(
    child: ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20.0),
      children: [
        Center(
          child: Text(
            'Start typing to search for task..',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ],
    ),
  );

  ///The message to be shown when the searchbar not empty
  ///and no results were found based on the search query
  Widget _noResultsPlaceHolder = Center(
    child: ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20.0),
      children: [
        Center(
          child: Text(
            'No tasks found that match the query',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ],
    ),
  );

  ///The message to be shown when the searchbar is not empty
  ///and an exception is thrown while sending the task request
  Widget _errorResultsPlaceHolder = Center(
    child: ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20.0),
      children: [
        Center(
          child: Text(
            'An error occurred',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ],
    ),
  );

  ///Generates a single list item that will contain the 
  ///task details with a click listener
  Material _searchViewResult(Task task) {
    return Material(
      color: Colors.white,
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
                  child: Text(
                    task.title.toString(),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 4, 0, 15),
                  child: Text(
                    task.description.toString(),
                    style: TextStyle(),
                  ),
                ),
              ],
            ),
            Divider(
              height: 0,
              color: Colors.black54,
            )
          ],
        ),
        onTap: () {
          setState(() {
            _currentTask = task;
            _searchOn = false;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    dio.onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };    
    if (_searchOn) {
      _searchResultsStack = Container(
        color: Colors.white,
        child: ListView(
          children: _searchViewResults,
        ),
      );
      _addUserBtn = null;
    } else {
      //Place the empty placeholder in the results
      _searchViewResults = [
        _emptySearchQueryPlaceholder
      ];
      _searchResultsStack = Text("");
      _addUserBtn = FloatingActionButton(
        child: Icon(
          Icons.person_add,
          color: Colors.white,
        ),
        backgroundColor: themeColor,
        onPressed: () {
          Navigator.pushNamed(context, RouteMapper.register);
        },
      );
    }
    if (currentUser == null) {
      _notSignedInMessage = Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text(
              "It appears you are not signed in. Please sign in to fetch tasks",
              style: TextStyle(
                color: themeColor,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: RaisedButton(
              color: themeColor,
              child: Text(
                "Sign In",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  RouteMapper.login,
                );
              },
            ),
          ),
        ],
      );
    }
    List<Widget> actions = [
      IconButton(
        icon: Icon(Icons.search, color: Colors.white),
        onPressed: () {
          setState(() {
            if (!_searchOn)
              _searchOn = true;
            else
              _searchOn = false;
          });
        },
      )
    ];
    Widget homeTitle = Text("Task Fetcher");
    if (_searchOn) {
      homeTitle = TextField(
        autofocus: true,
        cursorColor: Colors.white,
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          hintText: "Search",
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _searchOn = false;
              });
            },
          ),
        ),
        onChanged: (searchQuery) async {
          //Search the new contents of this field
          Response taskResponse;
          try{
            taskResponse = await dio.get(
              serverIp + ServerAPI.tasks,
              data: TaskRequest.toJSON(
                userSession: currentUser,
                taskId: searchQuery,
              ),
            );
            _searchViewResults = [];
          }
          catch(err){
            if(searchQuery.length > 0){
              setState(() {
                _searchViewResults = [
                  _errorResultsPlaceHolder
                ];
              }); 
            }
            else{
              setState(() {
                _searchViewResults = [
                  _emptySearchQueryPlaceholder
                ];
              }); 
            }
          }
          ///Data is sent from the server as JSON.
          dynamic tasks = taskResponse.data["task"];
          if(tasks == null)
            tasks = [];
          for (var x = 0; x < tasks.length; x++) {
            Task serializedTask = Task().fromJSON(tasks[x]);
            _searchViewResults.add(_searchViewResult(serializedTask));
          }
          if(tasks.length == 0 && searchQuery.length == 0){
            _searchViewResults = [
              _noResultsPlaceHolder
            ];
          }
          else
          if(searchQuery.length == 0){
            _searchViewResults = [
              _emptySearchQueryPlaceholder
            ];
          }
          setState(() {
            _searchViewResults = _searchViewResults;
          });
        },
      );
      actions = [];
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: homeTitle,
        actions: actions,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: [
                  Table(
                    border: TableBorder.all(
                      color: themeColor,
                    ),
                    columnWidths: {
                      0: FixedColumnWidth(90),
                    },
                    children: <TableRow>[
                      TableRow(
                        children: <Widget>[
                          Padding(
                            padding: _cellPadding,
                            child: Text(
                              "ID",
                              style: TextStyle(
                                color: themeColor,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Padding(
                            padding: _cellPadding,
                            child: Text(
                              _currentTask.id.toString(),
                              style: TextStyle(
                                color: themeColor,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          Padding(
                            padding: _cellPadding,
                            child: Text(
                              "Title",
                              style: TextStyle(
                                color: themeColor,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Padding(
                            padding: _cellPadding,
                            child: Text(
                              _currentTask.title.toString(),
                              style: TextStyle(
                                color: themeColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),                      
                      TableRow(
                        children: <Widget>[
                          Padding(
                            padding: _cellPadding,
                            child: Text(
                              "Desc.",
                              style: TextStyle(
                                color: themeColor,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Padding(
                            padding: _cellPadding,
                            child: Text(
                              _currentTask.description.toString(),
                              style: TextStyle(
                                color: themeColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: <Widget>[
                          Padding(
                            padding: _cellPadding,
                            child: Text(
                              "Done?",
                              style: TextStyle(
                                color: themeColor,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Padding(
                            padding: _cellPadding,
                            child: Text(
                              _currentTask.done ? "Yep" : "Nope",
                              style: TextStyle(
                                color: themeColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  _notSignedInMessage,
                ],
              ),
            ),
            //The SearchView Results Container
            _searchResultsStack
          ],
        ),
      ),
      floatingActionButton: _addUserBtn,
    );
  }
}

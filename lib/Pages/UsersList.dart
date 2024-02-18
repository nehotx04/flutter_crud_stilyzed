import 'dart:convert';
import 'package:flutter_crud_2/Pages/UserEditForm.dart';
import 'package:flutter_crud_2/models/User.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  List<User> userList = [];

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  Future<void> _getUsers() async {
    var url = Uri.parse('http://192.168.1.113:8080/api/users');

    var res = await http.get(url);
    if (res.statusCode == 200) {
      String responseBody = utf8.decode(res.bodyBytes);
      List<dynamic> data = json.decode(responseBody);
      List<User> users = data
          .map((user) => User(
                user['id'],
                limitText(user['name']),
                limitText(user['lastname']),
              ))
          .toList();
      setState(() {
        userList = users;
      });
      print("Request success: ${responseBody}");
    } else {
      print("Error in request: ${res.statusCode}");
    }
  }

  Future<bool> _deleteUsers(int id) async {
    var url = Uri.parse(
        'http://192.168.1.113:8080/api/users/delete/' + id.toString());
    var res = await http.delete(url);
    if (res.statusCode == 200) {
      print("User deleted");
      return true;
    } else {
      print("Request error: ${res.statusCode}");
      return false;
    }
  }

  String limitText(String text) {
    if (text.length > 6) {
      return text.substring(0, 6);
    } else {
      return text;
    }
  }

    Future<void> _refresh() async {
    setState(() {
      _getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text("List of users"),
      )),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child:ListView.builder(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
        ),
        itemCount: userList.length,
        itemBuilder: (context, index) {
          return Card.outlined(
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name: " + userList[index].name,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            "Lastname: " + userList[index].lastname,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Row(
                        children: [
                          TextButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.all(1.0)),
                              ),
                              child: Icon(Icons.edit),
                              onPressed: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UserEditForm(id:userList[index].id),
                                      ),
                                    )
                                  }),
                          TextButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.all(1.0)),
                              ),
                              child: Icon(Icons.delete),
                              onPressed: () => {
                                    _deleteUsers(userList[index].id)
                                        .then((bool success) {
                                      if (success) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('User Deleted'),
                                              content: Text(
                                                  'User deleted successfully'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Close'),
                                                  onPressed: () {
                                                    _getUsers();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }),
                                  }),
                        ],
                      ),
                    ],
                  )));
        },
      ),
    ));
  }
}

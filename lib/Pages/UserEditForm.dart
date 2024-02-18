import 'dart:convert';
import 'package:flutter_crud_2/models/User.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class UserEditForm extends StatefulWidget {
  final dynamic id;
  UserEditForm({Key? key, this.id}) : super(key: key);

  @override
  State<UserEditForm> createState() => _UserEditFormState();
}

class _UserEditFormState extends State<UserEditForm> {
  Future<void> _editUser(String name, String lastname) async {
    var url = Uri.parse(
        'http://192.168.1.113:8080/api/users/edit/' + widget.id.toString());
    var data = {'id': widget.id, 'name': name, 'lastname': lastname};

    var res = await http.put(
      url,
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode == 200) {
      print("Request success: ${res.body}");
    } else {
      print("Error in request: ${res.statusCode}");
    }
  }

List<User> userList = [];

Future<void> _getUser() async {
  var url = Uri.parse('http://192.168.1.113:8080/api/users/'+widget.id.toString());

  var res = await http.get(url);
  if (res.statusCode == 200) {
    String responseBody = utf8.decode(res.bodyBytes);
    Map<String, dynamic> data = json.decode(responseBody);
    
    User user = User(
      data['id'],
      data['name'],
      data['lastname'],
    );
    
    setState(() {
      userList.add(user);
      _lastnameFieldController = TextEditingController(text: userList[0].lastname.toString());
      _nameFieldController = TextEditingController(text: userList[0].name.toString());
    });

    print("Request success: ${responseBody}");
  } else {
    print("Error in request: ${res.statusCode}");
  }
}

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  final _formKey = GlobalKey<FormState>();

   TextEditingController _nameFieldController = TextEditingController();
   TextEditingController _lastnameFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "User Form",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      )),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          children: [
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
                controller: _nameFieldController,
                decoration: InputDecoration(
                  hintText: "Name",
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "must complete this field";
                  }
                }),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
                controller: _lastnameFieldController,
                decoration: InputDecoration(
                  hintText: "Lastname",
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "must complete this field";
                  }
                }),
            SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
                child: Text("Update"),
                onPressed: () => {
                      if (_formKey.currentState != null &&
                          _formKey.currentState!.validate())
                        {
                          _editUser(_nameFieldController.text,_lastnameFieldController.text),
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('User Edited!'),
                                content: Text('User Edited Successfully'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Close'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          )
                        }
                    }),
          ],
        ),
      ),
    );
  }
}

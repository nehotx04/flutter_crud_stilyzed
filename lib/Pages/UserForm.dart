import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {

Future<void> _createUser(String name, String lastname) async{
  var url = Uri.parse('http://192.168.1.113:8080/api/users');
  var data = {'name':name,'lastname':lastname};

  var res = await http.post(
    url,
    body: json.encode(data),
    headers: {'Content-Type': 'application/json'},
  );

  if(res.statusCode == 200){
    print("Request success: ${res.body}");
  }else{
    print("Error in request: ${res.statusCode}");
  }

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
      body:Form(
        key: _formKey,
        child:ListView(
          padding: EdgeInsets.only(left:20.0,right:20.0,),
          children: [

            SizedBox(height: 20.0,),
            TextFormField(
              controller: _nameFieldController,
              decoration: InputDecoration(hintText:"Name",),
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "must complete this field";
                }
              }
            ),

            SizedBox(height: 20.0,),
            TextFormField(
              controller: _lastnameFieldController,
              decoration: InputDecoration(hintText:"Lastname",),
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "must complete this field";
                }
              }
            ),
          SizedBox(height: 30.0,),
          ElevatedButton(
            child: Text("Enviar"),
            onPressed:()=>{
              
              if(_formKey.currentState != null && _formKey.currentState!.validate()){
                _createUser(_nameFieldController.text, _lastnameFieldController.text),

                _nameFieldController.clear(),
                _lastnameFieldController.clear(),

                showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog( 
                          title: Text('User created!'),
                          content: Text('User created successfully'),
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

            }
          ),

          ],
        ),
        ),
    );
  }
}
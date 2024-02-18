import 'package:flutter/material.dart';
import 'package:flutter_crud_2/Pages/UserForm.dart';
import 'package:flutter_crud_2/Pages/UsersList.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('Test app')),
        ),
        body: Container(
          child: ListView(
            padding: EdgeInsets.only(left:20.0,right:20.0,),
            children: [
              Center(
                  child: Text(
                "Users",
                style: TextStyle(color: Colors.blue),
              )),
              SizedBox(
                height: 20.0,
              ),

              Builder(
                builder: (context) => ElevatedButton(
                  child:
                      Text("Create Users", style: TextStyle(fontSize: 16.0)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserForm()));
                  },
                ),
              ),

              Builder(
                builder: (context) => ElevatedButton(
                  child:
                      Text("List Users", style: TextStyle(fontSize: 16.0)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UsersList()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

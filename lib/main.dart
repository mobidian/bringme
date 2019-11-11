import 'package:flutter/material.dart';
import 'package:bringme/root_page.dart';
import 'package:bringme/authentification/auth.dart';
import 'userProposition.dart';

void main() => runApp(new MyApp());



class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}


class _MyAppState extends State<MyApp>{

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
        title: 'Bring Me beta 0.1',
        theme: new ThemeData(
          primaryColor: Colors.black,
        ),
        routes:{
          '/': (BuildContext context) => new RootPage(auth: new Auth()),
          '/userProposition': (BuildContext context) => UserProposition(),
        });
//        home: new RootPage(auth: new Auth()));

  }
}
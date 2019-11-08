import 'package:flutter/material.dart';

void main(){
  //  debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Text("hello"),
        appBar: AppBar(
          title: Text('Bring me'),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'myDrawer.dart';

class UserProposition extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserPropositionState();
  }
}

class _UserPropositionState extends State<UserProposition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Proposition"),
      ),
      body: Center(
        child: Text("hello proposition"),
      ),
      drawer: MyDrawer("About"),
    );
  }
}

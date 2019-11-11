import 'package:flutter/material.dart';


class UserProposition extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _UserPropositionState();
  }
}


class _UserPropositionState extends State<UserProposition>{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("hello proposition"),
    );
  }
}
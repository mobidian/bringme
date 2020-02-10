import 'package:flutter/material.dart';
import 'myDrawer.dart';
import 'package:bringme/authentification/auth.dart';

class AProposUser extends StatefulWidget {

  final BaseAuth auth = new Auth();

  @override
  State<StatefulWidget> createState() {
    return _AProposUserState();
  }
}

class _AProposUserState extends State<AProposUser> {

  String _userId ='';

  @override
  void initState() {
    super.initState();
    widget.auth.currentUserId().then((id) {
      setState(() {
        _userId = id;
      });
    });
  }

  Widget constructPage() {
    return Center(
      child: Text('À Propos'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A Propos"),
      ),
      body: constructPage(),
      drawer: MyDrawer(currentPage: "aProposUser", userId: _userId,),
    );
  }
}

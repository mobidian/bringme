import 'package:flutter/material.dart';
import 'package:bringme/authentification/auth.dart';
import 'myDrawer.dart';
import 'package:bringme/user/home_page.dart';
import 'package:provider/provider.dart';
import 'package:bringme/main.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.auth, this.userId, this.logoutCallback});

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() {
    return _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage> {


  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Widget _pageContent() {
    double width = MediaQuery.of(context).size.width;

    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Image.asset("assets/AWID1080_trait.png"),
        ButtonTheme(
          minWidth: width/1.4,
          child: RaisedButton(
            elevation: 5.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            child: Text("Réserver un transporteur",
                style: TextStyle(color: Colors.white, fontSize: 20.0)),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            onPressed: () {
              Provider.of<DrawerStateInfo>(context).setCurrentDrawer(1);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage(
                userId: widget.userId,
              )));
            },
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Accueil"),
      ),
      body: _pageContent(),
      drawer: MyDrawer(
        currentPage: "welcome",
        userId: widget.userId,
        auth: widget.auth,
        logoutCallback: widget.logoutCallback,
      ),
    );
  }
}
